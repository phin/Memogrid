//
//  MGViewController.m
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-02-17.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "MGViewController.h"
#import "MGNextLevelViewController.h"
#import "MGMenuViewController.h"
#import "MGUserLevel.h"
#import <AudioToolbox/AudioServices.h>

@interface MGViewController ()

@end

@implementation MGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initVars]; // Init Variables
    [self initUI];   // Setup UI
    [self initGame]; // Init Game
}

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [self stopGuessing];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initPreGame];
    [self.view layoutSubviews];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [b_ready setHidden:YES];
    [UIView animateWithDuration:0.3 animations:^{
        l_currentlvl.alpha = 0;
        mg_square.alpha = 0;
        b_ready.alpha = 0;
    }];
}

#pragma mark - INITIALIZATION

- (void) initVars
{
    [self becomeFirstResponder];
    canPlay        = NO;
    debugMode      = YES;
}

- (void) initPreGame
{
    // Display Level starts at index 1, whereas real level starts at 0
    int current = [[MGUserLevel sharedInstance] current_level];
    l_currentlvl.text = [NSString stringWithFormat:@"%02d", current+1];
    
    // Set views
    [mg_square setHidden:YES];
    [b_ready setHidden:NO];
    [b_ready startBlinking];
    b_ready.userInteractionEnabled = YES;
    b_ready.alpha = 0;

    [UIView animateWithDuration:0.4 animations:^{
        mg_square.alpha = 0;
        l_currentlvl.alpha = 1;
        b_ready.alpha = 1;
    }];
}

- (void) initGame
{    
    // Init rectangle de jeu
    mg_square = [[MGSquare alloc] initWithFrame:[self getMainSquareFrameForOrientation:[self interfaceOrientation]]];
    mg_square.backgroundColor = [UIColor clearColor];
    mg_square.canPlay = canPlay;
    [self.view addSubview:mg_square];
    [self.view bringSubviewToFront:b_ready];
    
    mg_level = [[MGLevelManager alloc] init];
    [MGLevelManager init];
    
    // Detect if it is the user's first time
    BOOL isFirstTime = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstTime"];
    if (!isFirstTime) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstTime"];
        
        UIAlertView *firstTime = [[UIAlertView alloc] initWithTitle:nil message:@"Looks like it is your first time here. Do you want a quick tutorial?" delegate:self cancelButtonTitle:@"Not now" otherButtonTitles:@"Tutorial", nil];
        firstTime.tag = 234;
        [firstTime show];
    }
}

- (void) initUI
{
    self.view.backgroundColor = C_BACK;
}

- (CGRect) getMainSquareFrameForOrientation:(UIInterfaceOrientation)orientation
{
    float pos_x = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? [UIScreen mainScreen].bounds.size.width/2 - (((sq_SIZE+2) * ROWS)/2) : 1.5);
    float pos_y = [UIScreen mainScreen].bounds.size.height/2 - (((sq_SIZE+2) * ROWS)/2);
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        pos_x = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? [UIScreen mainScreen].bounds.size.height/2 - (((sq_SIZE+2) * ROWS)/2) : 1.5);
        pos_y = [UIScreen mainScreen].bounds.size.width/2 - (((sq_SIZE+2) * ROWS)/2);
    }
    CGRect rect_game = CGRectMake(pos_x, pos_y, (sq_SIZE+2) * ROWS, (sq_SIZE+2) * COLS);
    
    return rect_game;
}

#pragma mark - INTERFACE FUNCTIONS


- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    mg_square.frame = [self getMainSquareFrameForOrientation:toInterfaceOrientation];
}


#pragma mark - GAME INIT

- (IBAction) startGame
{    
    // Start Level

    [UIView animateWithDuration:0.3 animations:^{
        l_currentlvl.alpha = 0;
        [b_ready setHidden:YES];
        [mg_square setHidden:NO];
        b_ready.alpha   = 0;
        mg_square.alpha = 1;
    } completion:^(BOOL finished) {
        // Set user/view interactions
        b_ready.userInteractionEnabled = NO;
        [self stopGuessing];
        
        // Go to the next level from the UserLevel Singleton
        GameMode gm_current = [[MGUserLevel sharedInstance] current_mode];
        int current         = [[MGUserLevel sharedInstance] current_level];

        int difficulty = [MGLevelManager getDifficultyFromLevel:current andMode:gm_current];
        [self startGameWithLevel:current andDifficulty:difficulty andMode:gm_current];
    }];
}

#pragma mark - GAME FLOW FUNCTIONS

- (void) startGameWithLevel:(int)level andDifficulty:(int)difficulty andMode:(GameMode)mode
{
    level = (level > 24) ? 24 : level; // Don't go over 25
    difficulty = (debugMode) ? 4 : difficulty;
    
    [mg_square setGameWithDifficulty:difficulty andMode:mode];
    [self performSelector:@selector(startGuessing) withObject:self afterDelay:2];
}

- (void) startGuessing
{
    [self clear];
    [self userCanPlay:YES];
}

- (void) stopGuessing
{
    [self clear];
    [self userCanPlay:NO];
}

- (void) failedGame
{
    // 1. Show what the user should have tapped & vibrate
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    [self userCanPlay:NO];
    [mg_square showAnswer];
    
    // 2. Then go to the Lost page.
    [self performSelector:@selector(endedLevelWithSuccess:) withObject:NO afterDelay:1.0];
}

- (void) succeededGame
{
    [self userCanPlay:NO];
    // Call the end function with a delay so we can have time to show user's feedback
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self endedLevelWithSuccess:YES];
    });
}

- (void) endedLevelWithSuccess:(BOOL)didWin
{
    [self stopGuessing];
        
    if (didWin) {
        int current = [[MGUserLevel sharedInstance] current_level];
        GameMode mode = [[MGUserLevel sharedInstance] current_mode];
        [MGLevelManager setUserFinishedLevel:current forMode:mode];
        current++;
        
        // Switch from Classic to Sequence
        if (current >= 24 && mode == Classic) {
            mode = Sequence;
            current = 0;
            NSLog(@"Moving from Classic to Sequence");
            UIAlertView *al_nextMode = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"You completed the Classic mode. Now onto the Sequence mode." delegate:self cancelButtonTitle:@"Next" otherButtonTitles: nil];
            [al_nextMode show];
        }
        
        // Done the game!
        if (current >= 24 && mode == Sequence) {
            current--; // put it back for the same level.
            // Congratulations
            UIAlertView *al_done = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"You are one of the few to finish the two games modes that Memogrid offers at the time. Stay tuned for more Game modes and levels!" delegate:self cancelButtonTitle:@"Yay!" otherButtonTitles: nil];
            [al_done show];
        }
        
        [[MGUserLevel sharedInstance] setCurrentLevel:current forMode:mode];
        MGNextLevelViewController *vc_next = [[MGNextLevelViewController alloc] init];
        [self presentModalViewController:vc_next withPushDirection:kCATransitionFromTop];

    } else {
        // Start over
        [self initPreGame];
    }
    
}

#pragma mark - GAME FUNCTIONS

- (void) userCanPlay:(BOOL)usercanplay
{
    canPlay = usercanplay;
    mg_square.canPlay = canPlay;
    b_newgame.hidden = !usercanplay;
}

- (void) clear
{
    [mg_square clear];
}

- (IBAction)reset
{
    // DEBUG ACTIONS
    [self clear];
}

#pragma mark - SHAKE MOTION

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event { //RESTART NEW GAME WHEN iPHONE IS SHAKED
	if (event.subtype == UIEventSubtypeMotionShake)
	{
		UIAlertView * shakeAns = [[UIAlertView alloc]
                                  initWithTitle:@"Restart"
                                  message:@"Do you want to start a new game?"
                                  delegate:self
                                  cancelButtonTitle:@"NO"
                                  otherButtonTitles:@"OK",nil];
        shakeAns.tag = 2345;
		[shakeAns show];
	}
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 234) {
        // First time playing
        // Shaking alert
        if (buttonIndex == 1) {
            [self performSegueWithIdentifier:@"goToTutorial" sender:self];
            NSLog(@"Go to tutorial");
        } else {
            NSLog(@"Cancel Tutorial");
        }
    } else if (actionSheet.tag == 2345){
        // Shaking alert
        if (buttonIndex == 1) {
            [self startGame];
            NSLog(@"Reset");
        } else {
            NSLog(@"cancel");
        }
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}


@end
