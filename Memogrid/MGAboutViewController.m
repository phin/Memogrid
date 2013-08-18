//
//  MGAboutViewController.m
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-02-28.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "MGAboutViewController.h"

@interface MGAboutViewController ()

@end

@implementation MGAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

- (void) initUI
{
    self.view.backgroundColor = C_BACK;
}

- (IBAction)backToMenu:(id)sender
{
    [self dismissModalViewControllerWithPushDirection:kCATransitionFromBottom];
}


@end
