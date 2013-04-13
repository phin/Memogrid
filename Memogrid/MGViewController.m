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

@interface MGViewController ()

@end

@implementation MGViewController

static int i_current;

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
    [self animationPopFrontScaleUp];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!forceLevel) {
        // Start a the current game on that view
        
        // TODO : Fix the bug where if you force a level, it works, then switches back to the current user's level.
        
        [self startGame];
    } else {
        // User chose a level
        // Reset the trigger
        forceLevel = NO;
    }
}

#pragma mark - INITIALIZATION

- (void) initVars
{
    canPlay        = NO;
    multipleColors = NO;
    debugMode      = NO;
}

- (void) initGame
{    
    // Init rectangle de jeu
    mg_square = [[MGSquare alloc] initWithFrame:[self getMainSquareFrameForOrientation:[self interfaceOrientation]]];
    mg_square.backgroundColor = [UIColor clearColor];
    mg_square.canPlay = canPlay;
    [self.view addSubview:mg_square];
    
    mg_level = [[MGLevelManager alloc] init];
    [MGLevelManager init];
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

- (void) initUI
{    
    // Background
    noiseBackView = [[KGNoiseLinearGradientView alloc] initWithFrame:self.view.bounds];
    noiseBackView.backgroundColor = [UIColor colorWithRed:237./255. green:231./255. blue:224./255. alpha:1.000];
    noiseBackView.noiseBlendMode = kCGBlendModeMultiply;
    noiseBackView.noiseOpacity = 0.05;
    [self.view insertSubview:noiseBackView atIndex:0];
}

#pragma mark - INTERFACE FUNCTIONS


- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    mg_square.frame = [self getMainSquareFrameForOrientation:toInterfaceOrientation];
    [self viewWillLayoutSubviews];
}

- (void)viewWillLayoutSubviews
{
    noiseBackView.frame = self.view.bounds;
    [super viewWillLayoutSubviews];
}


#pragma mark - GAME INIT

- (void) startLevel:(int)level forMode:(NSString *)mode
{
    // Start Level Manually
    
    i_current  = level;
    forceLevel = TRUE;
    
    // Set the level that the user chose.
    GameMode gm_mode = Classic;
    if ([mode isEqualToString:@"Bicolor"]) {
        gm_mode = Bicolor;
    } else if ([mode isEqualToString:@"Sequence"]) {
        gm_mode = Simon;
    }

    int difficulty = [MGLevelManager getDifficultyFromLevel:level andMode:gm_mode];
    [self startGameWithLevel:level andDifficulty:difficulty];
}

- (IBAction) startGame
{    
    // Start Level Automatically
    
    // Current mode
    GameMode gm_current = Classic;
    
    // Set user/view interactions
    [self stopGuessing];
    
    if ([MGLevelManager finishedGameMode:gm_current]) {
        //Go back to the main menu
        [self performSegueWithIdentifier:@"gameToMenu" sender:self];
    } else {

        // Next level
        int current    = 0;
        int difficulty = [MGLevelManager getDifficultyFromLevel:current andMode:gm_current];
        
        if (i_current) {
            // Keep going with the level the user chose
            i_current++;
            NSLog(@"Chosen by user: %i", i_current);
            current = i_current;
        } else {
            // Go to the next level from the user's current achievements
            current = [MGLevelManager getUserCurrentLevelForMode:gm_current];
        }

        [self startGameWithLevel:current andDifficulty:difficulty];
    }
}

#pragma mark - GAME FLOW FUNCTIONS

- (void) startGameWithLevel:(int)level andDifficulty:(int)difficulty
{    
    difficulty = (debugMode) ? 1 : difficulty;
    
    l_currentlvl.text = [NSString stringWithFormat:@"%02d", level+1];
    [mg_square setGameWithDifficulty:difficulty];
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
    // 1. TODO : Show what the user should have tapped.
    
    // 2. Then go to the Lost page.
    [self endedLevelWithSuccess:NO];
}

- (void) succeededGame
{
    [self endedLevelWithSuccess:YES];
}

- (void) endedLevelWithSuccess:(BOOL)didWin
{
    [self stopGuessing];
        
    if (didWin) {
        int current = [MGLevelManager getUserCurrentLevelForMode:Classic];

        if (i_current) {
            // User is playing with another level
            current = i_current;
        }
        
        [MGLevelManager setUserFinishedLevel:current forMode:Classic];
    }
    
    MGNextLevelViewController *vc_next = [[MGNextLevelViewController alloc] init];
    vc_next.didWin = didWin;
    [self presentViewController:vc_next animated:YES completion:nil];
    [self animationPushBackScaleDown];
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
        MGMenuViewController *vc_menu = [segue destinationViewController];
        vc_menu.delegate = (id)self;
        i_current = 0;
        [self animationPushBackScaleDown];
    }
}

#pragma mark - UNLOAD

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
