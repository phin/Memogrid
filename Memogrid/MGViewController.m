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

    [self startGame];
}

#pragma mark - INITIALIZATION

- (void) initVars
{
    canPlay        = NO;
    multipleColors = NO;
    debugMode      = YES;
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

- (IBAction) startGame
{    
    // Start Level Automatically
    
    // Current mode
    GameMode gm_current = Simon;
    
    // Set user/view interactions
    [self stopGuessing];
    
    // Next level
    int current = 0;
    
    // Go to the next level from the user's current achievements
    current = [MGLevelManager getUserCurrentLevelForMode:gm_current];
    
    int difficulty = [MGLevelManager getDifficultyFromLevel:current andMode:gm_current];
    [self startGameWithLevel:current andDifficulty:difficulty andMode:gm_current];
}

#pragma mark - GAME FLOW FUNCTIONS

- (void) startGameWithLevel:(int)level andDifficulty:(int)difficulty andMode:(GameMode)mode
{
    level = (level > 25) ? 25 : level;
    difficulty = (debugMode) ? 3 : difficulty;
    
    l_currentlvl.text = [NSString stringWithFormat:@"%02d", level+1];
    
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
    // 1. Show what the user should have tapped.
    [self userCanPlay:NO];
    [mg_square showAnswer];
    
    // 2. Then go to the Lost page.
    [self performSelector:@selector(endedLevelWithSuccess:) withObject:NO afterDelay:1.0];
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
