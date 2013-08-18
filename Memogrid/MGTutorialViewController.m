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

@synthesize pv_tutorial, pc_tutorial;


#pragma mark - Init

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    [self initTutorial];
}


- (void) initUI {
    self.view.backgroundColor = C_BACK;
}

- (void) initTutorial {
    pv_tutorial.delegate = self;
    pv_tutorial.dataSource = self;
    pv_tutorial.pageControl = pc_tutorial;
    pv_tutorial.minimumPageAlpha = 0.6;
    pv_tutorial.minimumPageScale = 1.0;
    
    a_tutorials = [[NSMutableArray alloc] initWithObjects:[UIColor blackColor], [UIColor redColor], [UIColor greenColor], [UIColor yellowColor], nil];
}

#pragma mark - Flow

- (IBAction)goBackToGame:(id)sender {
    id p;
    for (p = [self presentingViewController]; p && [p class] != [MGViewController class]; p = [p presentingViewController]);
    /* Empty for body */
    
    if (FANCY_TRANSITION) {
        [p dismissModalViewControllerAnimated:NO];
    } else {
        [p dismissNatGeoViewController];
    }
}

#pragma mark -
#pragma mark PagedFlowView Delegate

- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView {
    
    return CGSizeMake(320, 355);
}

- (void)didChangePageToIndex:(int)index forFlowView:(PagedFlowView *)flowView {
    
    NSLog(@"didChangePageToIndex: %i forFlowView:%i", index, flowView.tag);
}


#pragma mark -
#pragma mark PagedFlowView Datasource

- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView {
    return 4;
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    UIView *v_tutoriel = (UIView *)[flowView dequeueReusableCell];
    if (!v_tutoriel) {
        v_tutoriel = [[UIView alloc] init];
    }
    v_tutoriel.backgroundColor = [a_tutorials objectAtIndex:index];
    return v_tutoriel;
}


@end
