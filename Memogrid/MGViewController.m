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
    [self userCanPlay:NO];

    // Set the level.
    int difficulty = [MGLevelManager userCurrentLevelForMode:Classic];
    [mg_square setGameWithDifficulty:difficulty];
    
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
    
    UIView *test = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self presentWithSuperview:test];
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

#pragma mark - Next Level

// Add this view to superview, and slide it in from the bottom
- (void)presentWithSuperview:(UIView *)superview {
    // Set initial location at bottom of superview
    CGRect frame = self.view.frame;
    frame.origin = CGPointMake(0.0, superview.bounds.size.height);
    self.view.frame = frame;
    [superview addSubview:self.view];
    
    // Animate to new location
    [UIView beginAnimations:@"presentWithSuperview" context:nil];
    frame.origin = CGPointZero;
    self.view.frame = frame;
    [UIView commitAnimations];
}

// Method called when removeFromSuperviewWithAnimation's animation completes
- (void)animationDidStop:(NSString *)animationID
                finished:(NSNumber *)finished
                 context:(void *)context {
    if ([animationID isEqualToString:@"removeFromSuperviewWithAnimation"]) {
        [self.view removeFromSuperview];
    }
}

// Slide this view to bottom of superview, then remove from superview
- (void)removeFromSuperviewWithAnimation {
    [UIView beginAnimations:@"removeFromSuperviewWithAnimation" context:nil];
    
    // Set delegate and selector to remove from superview when animation completes
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    // Move this view to bottom of superview
    CGRect frame = self.view.frame;
    frame.origin = CGPointMake(0.0, self.view.superview.bounds.size.height);
    self.view.frame = frame;
    
    [UIView commitAnimations];
}

#pragma mark - UNLOAD

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
