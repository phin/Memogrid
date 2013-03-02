//
//  MGTutorialViewController.m
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-03-02.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "MGTutorialViewController.h"
#import "MGViewController.h"

@interface MGTutorialViewController ()

@end

@implementation MGTutorialViewController

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
	// Do any additional setup after loading the view.
}


- (IBAction)goBackToGame:(id)sender {
    id p;
    for (p = [self presentingViewController]; p && [p class] != [MGViewController class]; p = [p presentingViewController]);
    /* Empty for body */
    [p dismissModalViewControllerAnimated:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
