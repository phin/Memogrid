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

@interface MGNextLevelViewController ()

@end

@implementation MGNextLevelViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void) initUI {
    self.view.backgroundColor = C_GREEN;
    
    NSString *s_next = @"Next Level";
    
    MGButton *b_next = [[MGButton alloc] initWithFrame:CGRectMake(35, 220, 250, 55)];
    [b_next setTitle:s_next forState:UIControlStateNormal];
    [b_next addTarget:self action:@selector(nextLevel:) forControlEvents:UIControlEventTouchUpInside];
    [b_next startBlinking];
    [self.view addSubview:b_next];
    
    MGButton *b_level = [[MGButton alloc] initWithFrame:CGRectMake(35, self.view.frame.size.height-200, 250, 55)];
    [b_level setTitle:@"Choose Level" forState:UIControlStateNormal];
    [b_level addTarget:self action:@selector(goToMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b_level];

    MGButton *b_fb = [[MGButton alloc] initWithFrame:CGRectMake(35, self.view.frame.size.height-140, 250, 55)];
    [b_fb setTitle:@"Share on Facebook" forState:UIControlStateNormal];
    [b_fb addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b_fb];
    
    MGButton *b_tw = [[MGButton alloc] initWithFrame:CGRectMake(35, self.view.frame.size.height-80, 250, 55)];
    [b_tw setTitle:@"Share on Twitter" forState:UIControlStateNormal];
    [b_tw addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b_tw];
    
    MGMenuButton *mb_menu = [[MGMenuButton alloc] initWithFrame:CGRectMake(265, 20, 35, 33)];
    [mb_menu addTarget:self action:@selector(goToMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mb_menu];
    
    UILabel *l_message = [[UILabel alloc] initWithFrame:CGRectMake(35, 96, 250, 55)];
    l_message.backgroundColor = [UIColor clearColor];
    l_message.font            = [UIFont fontWithName:@"VerbBlack" size:22];
    l_message.textColor       = C_LIGHT;
    l_message.textAlignment   = NSTextAlignmentCenter;
    l_message.text            = @"You won!";
    [self.view addSubview:l_message];
}

- (IBAction)nextLevel:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self dismissNatGeoViewController];
}

- (IBAction)goToMenu:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    MGMenuViewController *vc_menu = [storyboard instantiateViewControllerWithIdentifier:@"MGMenuViewController"];
    vc_menu.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //[self presentViewController:vc_menu animated:YES completion:nil];
    [self presentNatGeoViewController:vc_menu];
}


@end
