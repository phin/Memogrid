//
//  MGNextLevelViewController.m
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-03-09.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "MGNextLevelViewController.h"

@interface MGNextLevelViewController ()

@end

@implementation MGNextLevelViewController

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
    [b_next setTitle:@"Next Level" forState:UIControlStateNormal];
    [b_next addTarget:self action:@selector(nextLevel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b_next];
}

- (IBAction)nextLevel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
