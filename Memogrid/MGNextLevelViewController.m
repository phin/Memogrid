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
    
    // Next Level, centré dans l'écran
    MGButton *b_next = [[MGButton alloc] initWithFrame:CGRectMake(35, (self.view.frame.size.height/2)-(55/2), 250, 55)];
    [b_next setTitle:s_next forState:UIControlStateNormal];
    [b_next addTarget:self action:@selector(nextLevel:) forControlEvents:UIControlEventTouchUpInside];
    [b_next startBlinking];
    [self.view addSubview:b_next];
    
    // TODO : A mettre en pictos
    MGButton *b_level = [[MGButton alloc] initWithFrame:CGRectMake(35, self.view.frame.size.height-140, 250, 55)];
    [b_level setTitle:@"Replay Level" forState:UIControlStateNormal];
    [b_level addTarget:self action:@selector(goToMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b_level];

    MGButton *b_fb = [[MGButton alloc] initWithFrame:CGRectMake(35, self.view.frame.size.height-80, 122.5, 55)];
    [b_fb setTitle:@"Facebook" forState:UIControlStateNormal];
    [b_fb addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b_fb];
    
    MGButton *b_tw = [[MGButton alloc] initWithFrame:CGRectMake(35+122.5+5, self.view.frame.size.height-80, 122.5, 55)];
    [b_tw setTitle:@"Twitter" forState:UIControlStateNormal];
    [b_tw addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b_tw];
    
    MGMenuButton *mb_menu = [[MGMenuButton alloc] initWithFrame:CGRectMake(265, 20, 35, 33)];
    [mb_menu addTarget:self action:@selector(goToMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mb_menu];
    
    UIImageView *iv_check = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]];
    iv_check.frame = CGRectMake(87, 80, 146, 159);
    [self.view addSubview:iv_check];
}

- (IBAction)nextLevel:(id)sender {
    if (FANCY_TRANSITION) {[self dismissNatGeoViewController];} else {[self dismissViewControllerAnimated:YES completion:nil];};
}

- (IBAction)goToMenu:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    MGMenuViewController *vc_menu = [storyboard instantiateViewControllerWithIdentifier:@"MGMenuViewController"];
    vc_menu.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    if (FANCY_TRANSITION) {
        [self presentNatGeoViewController:vc_menu];
    } else {
        [self presentViewController:vc_menu animated:YES completion:nil];
    }
}


@end
