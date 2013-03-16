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

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self animationPopFrontScaleUp];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Start a new game on that view
    [self startGame];
}

#pragma mark - INITIALIZATION

- (void) initVars {
    canPlay        = NO;
    multipleColors = NO;
    debugMode      = YES;
}

- (void) initGame {
    // Init rectangle de jeu
    mg_square = [[MGSquare alloc] initWithFrame:[self getMainSquareFrameForOrientation:[self interfaceOrientation]]];
    mg_square.backgroundColor = [UIColor clearColor];
    mg_square.canPlay = canPlay;
    [self.view addSubview:mg_square];
    
    mg_level = [[MGLevelManager alloc] init];
}

- (CGRect) getMainSquareFrameForOrientation:(UIInterfaceOrientation)orientation {
    float pos_x = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? [UIScreen mainScreen].bounds.size.width/2 - (((sq_SIZE+2) * ROWS)/2) : 1.5);
    float pos_y = [UIScreen mainScreen].bounds.size.height/2 - (((sq_SIZE+2) * ROWS)/2);
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        pos_x = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? [UIScreen mainScreen].bounds.size.height/2 - (((sq_SIZE+2) * ROWS)/2) : 1.5);
        pos_y = [UIScreen mainScreen].bounds.size.width/2 - (((sq_SIZE+2) * ROWS)/2);
    }
    CGRect rect_game = CGRectMake(pos_x, pos_y, (sq_SIZE+2) * ROWS, (sq_SIZE+2) * COLS);
    return rect_game;
}

- (void) initUI {
    
    // Background
    noiseBackView = [[KGNoiseLinearGradientView alloc] initWithFrame:self.view.bounds];
    noiseBackView.backgroundColor = [UIColor colorWithRed:228./255. green:216./255. blue:204./255. alpha:1.000];
    noiseBackView.noiseBlendMode = kCGBlendModeMultiply;
    noiseBackView.noiseOpacity = 0.05;
    [self.view insertSubview:noiseBackView atIndex:0];
}

#pragma mark - INTERFACE FUNCTIONS

- (void) hideControls {
    
}

- (void) showControls {
    
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    mg_square.frame = [self getMainSquareFrameForOrientation:toInterfaceOrientation];
    [self viewWillLayoutSubviews];
}

- (void)viewWillLayoutSubviews {
    noiseBackView.frame = self.view.bounds;
    [super viewWillLayoutSubviews];
}


#pragma mark - GAME FLOW FUNCTIONS

- (IBAction) startGame {
    // Set user/view interactions
    [self stopGuessing];

    // Set the level.
    int difficulty = [MGLevelManager userCurrentLevelForMode:Classic];
    [mg_square setGameWithDifficulty:difficulty];
    
    [self performSelector:@selector(startGuessing) withObject:self afterDelay:2.5];
}

- (void) startGuessing {
    [self clear];
    [self userCanPlay:YES];
}

- (void) stopGuessing {
    [self clear];
    [self userCanPlay:NO];
}

- (void) failedGame {
    UIAlertView *alert_fail = [[UIAlertView alloc] initWithTitle:@"Wrong Tile" message:@"Try again!" delegate:nil cancelButtonTitle:@"Replay" otherButtonTitles: nil];
    [alert_fail show];
    // TODO : Reset Game
    //[self clear];
    //[self startGame];
}

- (void) succeededGame {

    [self stopGuessing];
    
    MGNextLevelViewController *vc_next = [[MGNextLevelViewController alloc] init];
    [self presentViewController:vc_next animated:YES completion:nil];
    [self animationPushBackScaleDown];
}


#pragma mark - GAME FUNCTIONS

- (void) userCanPlay:(BOOL)usercanplay {
    canPlay = usercanplay;
    mg_square.canPlay = canPlay;
}

- (void) clear {
    [mg_square clear];
}

- (IBAction)reset {
    // DEBUG ACTIONS
    [self clear];
}

#pragma mark - Next Level

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"gameToMenu"]) {
        //MGMenuViewController * vc_menu = [segue destinationViewController];
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
