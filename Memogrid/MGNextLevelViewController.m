//
//  MGNextLevelViewController.m
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-03-09.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "MGMenuViewController.h"
#import "MGNextLevelViewController.h"
#import "MGMenuButton.h"
#import "MGLevelManager.h"

@interface MGNextLevelViewController () {
    MGButton *b_next;
    MGButton *b_level;
    MGButton *b_fb;
    MGButton *b_tw;
    MGMenuButton *mb_menu;
    UIImageView *iv_check;
}
@end

@implementation MGNextLevelViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

- (void) initUI {
    //self.view.backgroundColor = C_BACK;
    
    NSString *s_next = NSLocalizedString(@"next_level", nil);
    
    // Next Level, centré dans l'écran
    b_next = [[MGButton alloc] initWithFrame:CGRectMake(35, (self.view.frame.size.height/2)-(55/2), 250, 55)];
    [b_next setTitle:s_next forState:UIControlStateNormal];
    [b_next addTarget:self action:@selector(nextLevel:) forControlEvents:UIControlEventTouchUpInside];
    [b_next startBlinking];
    [self.view addSubview:b_next];
    
    b_level = [[MGButton alloc] initWithFrame:CGRectMake(35, self.view.frame.size.height-140, 250, 55)];
    [b_level setTitle:NSLocalizedString(@"replay_level", nil) forState:UIControlStateNormal];
    [b_level addTarget:self action:@selector(replayLevel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b_level];

    b_fb = [[MGButton alloc] initWithFrame:CGRectMake(35, self.view.frame.size.height-80, 122.5, 55)];
    [b_fb setTitle:@"Facebook" forState:UIControlStateNormal];
    [b_fb addTarget:self action:@selector(shareFacebook) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b_fb];
    
    b_tw = [[MGButton alloc] initWithFrame:CGRectMake(35+122.5+5, self.view.frame.size.height-80, 122.5, 55)];
    [b_tw setTitle:@"Twitter" forState:UIControlStateNormal];
    [b_tw addTarget:self action:@selector(shareTwitter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b_tw];
    
    mb_menu = [[MGMenuButton alloc] initWithFrame:CGRectMake(265, 20, 35, 33)];
    [mb_menu addTarget:self action:@selector(goToMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mb_menu];
    
    iv_check = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]];
    iv_check.frame = CGRectMake(87, (IS_IPHONE_5) ? 80 : 40, 146, 159);
    [self.view addSubview:iv_check];
    
    [self refreshPadLayout];
}

- (void)refreshPadLayout {
    // TOFIX
    // Since we did that part later on, do it separated so we don't touch at the iPhone's layout
    if (IS_IPAD) {
        b_next.frame = CGRectMake(self.view.bounds.size.height/2-b_next.frame.size.width/2, self.view.bounds.size.width/2-b_next.frame.size.height/2, b_next.frame.size.width, b_next.frame.size.height);
        b_level.frame = CGRectMake(0, 0, b_level.frame.size.width, b_level.frame.size.height);
        b_fb.frame = CGRectMake(0, 0, b_fb.frame.size.width, b_fb.frame.size.height);
        b_tw.frame = CGRectMake(0, 0, b_tw.frame.size.width, b_tw.frame.size.height);
        mb_menu.frame = CGRectMake(self.view.bounds.size.height-55, 20, mb_menu.frame.size.width, mb_menu.frame.size.height);
        iv_check.frame = CGRectMake(self.view.bounds.size.height/2-iv_check.frame.size.width/2, 160, iv_check.frame.size.width, iv_check.frame.size.height);
        
        // TODO : Finish the buttons
    }
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self refreshPadLayout];
}


- (IBAction)nextLevel:(id)sender {
    [self dismissModalViewControllerWithPushDirection:kCATransitionFromBottom];
}

- (IBAction)replayLevel:(id)sender
{
    // Decrement the current level of one so we start again with the same level
    int current = [[MGUserLevel sharedInstance] current_level];
    current--;
    [[MGUserLevel sharedInstance] setCurrentLevel:current forMode:[[MGUserLevel sharedInstance] current_mode]];
    
    // Go back to the Game
    [self nextLevel:nil];
}

- (IBAction)goToMenu:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    MGMenuViewController *vc_menu = [storyboard instantiateViewControllerWithIdentifier:@"MGMenuViewController"];
    vc_menu.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:vc_menu withPushDirection:kCATransitionFromTop];
}

- (void)shareFacebook {
    [self actionShareOnFacebook:NSLocalizedString(@"social", nil)];
}

- (void)shareTwitter {
    [self actionShareOnTwitter:NSLocalizedString(@"social", nil)];
}


@end
