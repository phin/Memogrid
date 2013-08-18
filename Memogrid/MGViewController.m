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
//    [b_ready setHidden:YES];
//    [UIView animateWithDuration:0.3 animations:^{
//        l_currentlvl.alpha = 0;
//        mg_square.alpha = 0;
//        b_ready.alpha = 0;
//    }];
}

#pragma mark - INITIALIZATION

- (void) initVars
{
    [self becomeFirstResponder];
    canPlay        = NO;
    debugMode      = NO;
}

- (void) initPreGame
{
    int current = [[MGUserLevel sharedInstance] current_level];
    // Display Level starts at index 1, whereas real level starts at 0
    l_currentlvl.text = [NSString stringWithFormat:@"%02d", current+1];
    
    // Set views
    [mg_square setHidden:YES];
    [b_ready setHidden:NO];
    [b_ready startBlinking];
    b_ready.userInteractionEnabled = YES;
    b_ready.alpha = 0;
    
    // Refresh button layouts (bug with transition Animation.)
    // Center the b_ready button
   // b_ready.frame = CGRectMake(self.view.frame.size.width/2-b_ready.frame.size.width/2, self.view.frame.size.height/2-b_ready.frame.size.height/2, b_ready.frame.size.width, b_ready.frame.size.height);
    

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
    level = (level > 25) ? 25 : level;
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
        [MGLevelManager setUserFinishedLevel:current forMode:[[MGUserLevel sharedInstance] current_mode]];
        current++;
        [[MGUserLevel sharedInstance] setCurrentLevel:current forMode:[[MGUserLevel sharedInstance] current_mode]];
        
        MGNextLevelViewController *vc_next = [[MGNextLevelViewController alloc] init];
        [self presentModalViewController:vc_next withPushDirection:kCATransitionFromTop];

    } else {
        [self initPreGame];
        // TODO : Try again with a word : "Try again".
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

#pragma mark - NEXT LEVEL

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"gameToMenu"]) {
        //[self animationPushBackScaleDown];
        
    }
}

#pragma mark - SHAKE MOTION

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event { //RESTART NEW GAME WHEN iPHONE IS SHAKED
	if (event.subtype == UIEventSubtypeMotionShake)
	{
		UIAlertView * shakeAns = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"l_shakeTitle", @"")
                                  message:NSLocalizedString(@"l_shakeMessage", @"")
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"l_shakeAnswer1", @"")
                                  otherButtonTitles:NSLocalizedString(@"l_shakeAnswer2", @""),nil];
		[shakeAns show];
	}
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Shaking alert
    if (buttonIndex == 1) {
        [self startGame];
        NSLog(@"Reset");
    } else {
        NSLog(@"cancel");
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}


@end
