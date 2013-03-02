//
//  MGViewController.m
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-02-17.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "MGViewController.h"

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
    //[self.view addSubview:noiseBackView];
    
    // Main Title
//    UILabel *l_title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 50)];
//    l_title.textColor = [UIColor whiteColor];
//    l_title.textAlignment = NSTextAlignmentCenter;
//    l_title.font = [UIFont fontWithName:@"VerbBlack" size:40.0];
//    l_title.backgroundColor = [UIColor clearColor];
//    l_title.text = @"Memogrid";
//    l_title.shadowColor = [UIColor darkGrayColor];
//    l_title.shadowOffset = CGSizeMake(0, 1);
//    [self.view addSubview:l_title];
    
//    UIButton *b_reset = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [b_reset setFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 150, 100, 44)];
//    [b_reset setTitle:@"Reset" forState:UIControlStateNormal];
//    [b_reset addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:b_reset];
    
    UIButton *b_next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [b_next setFrame:CGRectMake(200, [UIScreen mainScreen].bounds.size.height - 150, 100, 44)];
    [b_next setTitle:@"New Game" forState:UIControlStateNormal];
    [b_next addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b_next];
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
    
    [self userCanPlay:NO];
    [mg_square setGameWithDifficulty:5];
    
    [self performSelector:@selector(startGuessing) withObject:self afterDelay:2.5];
}

- (void) startGuessing {
    [self clear];
    [self userCanPlay:YES];
    
}

- (void) failedGame {
    UIAlertView *alert_fail = [[UIAlertView alloc] initWithTitle:@"Wrong Tile" message:@"Try again!" delegate:nil cancelButtonTitle:@"Replay" otherButtonTitles: nil];
    [alert_fail show];
    // TODO : Reset Game
    //[self clear];
    //[self startGame];
}

- (void) succeededGame {
    UIAlertView *alert_fail = [[UIAlertView alloc] initWithTitle:@"Congratulations" message:@"You did it!" delegate:nil cancelButtonTitle:@"Next level" otherButtonTitles: nil];
    [alert_fail show];
    [self clear];
    [self userCanPlay:NO];
    //[self startGame];
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


#pragma mark - UNLOAD

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
