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
    CGRect rect_game = CGRectMake(1.5, 88, (sq_SIZE+2) * ROWS, (sq_SIZE+2) * COLS);
    mg_square = [[MGSquare alloc] initWithFrame:rect_game];
    mg_square.backgroundColor = [UIColor clearColor];
    mg_square.canPlay = canPlay;
    [self.view addSubview:mg_square];
}

- (void) initUI {
    
    // Background
    KGNoiseLinearGradientView *noiseNavbarView = [[KGNoiseLinearGradientView alloc] initWithFrame:self.view.frame];
    noiseNavbarView.backgroundColor = [UIColor colorWithRed:228./255. green:216./255. blue:204./255. alpha:1.000];
    noiseNavbarView.noiseBlendMode = kCGBlendModeMultiply;
    noiseNavbarView.noiseOpacity = 0.05;
    [self.view addSubview:noiseNavbarView];
    
    // Main Title
    UILabel *l_title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 50)];
    l_title.textColor = [UIColor whiteColor];
    l_title.textAlignment = NSTextAlignmentCenter;
    l_title.font = [UIFont fontWithName:@"VerbBlack" size:40.0];
    l_title.backgroundColor = [UIColor clearColor];
    l_title.text = @"Memogrid";
    l_title.shadowColor = [UIColor darkGrayColor];
    l_title.shadowOffset = CGSizeMake(0, 1);
    [self.view addSubview:l_title];
    
    UIButton *b_reset = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [b_reset setFrame:CGRectMake(20, 450, 100, 44)];
    [b_reset setTitle:@"Reset" forState:UIControlStateNormal];
    [b_reset addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b_reset];
    
    UIButton *b_next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [b_next setFrame:CGRectMake(200, 450, 100, 44)];
    [b_next setTitle:@"New Game" forState:UIControlStateNormal];
    [b_next addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b_next];
}


#pragma mark - GAME FLOW FUNCTIONS

- (IBAction)reset {
    [mg_square clear];
}

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
}

- (void) endGame {
    
}


#pragma mark - GAME FUNCTIONS

- (void) userCanPlay:(BOOL)usercanplay {
    canPlay = usercanplay;
    mg_square.canPlay = canPlay;
}

- (void) clear {
    [mg_square clear];
}


#pragma mark - UNLOAD

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
