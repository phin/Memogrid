//
//  MGNextLevelViewController.m
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-03-09.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "MGNextLevelViewController.h"
#import "MGMenuViewController.h"

@interface MGNextLevelViewController ()

@end

@implementation MGNextLevelViewController

@synthesize didWin;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self animationPopFrontScaleUp];
}

- (void) initUI {
    // Temporary
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *b_next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    b_next.frame = CGRectMake(20, 220, 280, 50);
    [b_next setTitle:(didWin) ? @"Next Level" : @"Try again!" forState:UIControlStateNormal];
    [b_next addTarget:self action:@selector(nextLevel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b_next];
    
    UIButton *b_menu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    b_menu.frame = CGRectMake(240, 20, 65, 44);
    [b_menu setTitle:@"Menu" forState:UIControlStateNormal];
    [b_menu addTarget:self action:@selector(goToMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b_menu];
}

- (IBAction)nextLevel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goToMenu:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    MGMenuViewController *vc_menu = [storyboard instantiateViewControllerWithIdentifier:@"MGMenuViewController"];
    [self presentViewController:vc_menu animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
