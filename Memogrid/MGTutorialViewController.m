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
    
    [PFAnalytics trackEvent:@"Tutorial"];
}


- (void) initUI {
    self.view.backgroundColor = C_BACK;
}

- (void) initTutorial {
    pv_tutorial = [[PagedFlowView alloc] initWithFrame:CGRectMake(0, (IS_IPHONE_5) ? 45 : 10, 320.0, 355.0)];
    pv_tutorial.delegate = self;
    pv_tutorial.dataSource = self;
    pv_tutorial.pageControl = pc_tutorial;
    pv_tutorial.minimumPageAlpha = 0.6;
    pv_tutorial.minimumPageScale = 1.0;
    [self.view addSubview:pv_tutorial];
    
    // TOFIX : Do code instead of Images for translation...
    a_tutorials = @[@"Tutorial00.png", @"Tutorial01.png"];
}

#pragma mark - Flow

- (IBAction)goBackToGame:(id)sender {
    id p;
    for (p = [self presentingViewController]; p && [p class] != [MGViewController class]; p = [p presentingViewController]);
    /* Empty for body */
    [p dismissModalViewControllerWithPushDirection:kCATransitionFromBottom];
}

#pragma mark -
#pragma mark PagedFlowView Delegate

- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView {
    
    return CGSizeMake(320, 355);
}


#pragma mark -
#pragma mark PagedFlowView Datasource

- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView {
    return 2;
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    //UIView *v_tutoriel = (UIView *)[flowView dequeueReusableCell]; // TOFIX makes the class crash.
    UIImageView *v_tutoriel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[a_tutorials objectAtIndex:index]]];
    v_tutoriel.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *l_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 27.0, self.view.frame.size.width, 35)];
    l_title.text          = (index == 0) ? NSLocalizedString(@"CLASSIC", nil) : NSLocalizedString(@"SEQUENCE", nil);
    l_title.font          = [UIFont fontWithName:@"Futura" size:30.0];
    l_title.textColor     = [UIColor whiteColor];
    l_title.textAlignment = NSTextAlignmentCenter;
    [v_tutoriel addSubview:l_title];
    
    UITextView *tv_explaination = [[UITextView alloc] initWithFrame:CGRectMake(0, 275, 320, 100)];
    tv_explaination.text            = (index == 0) ? NSLocalizedString(@"tutorial_1", nil) : NSLocalizedString(@"tutorial_2", nil);
    tv_explaination.font            = [UIFont fontWithName:@"Futura" size:20.0];
    tv_explaination.textColor       = [UIColor whiteColor];
    tv_explaination.backgroundColor = [UIColor clearColor];
    tv_explaination.textAlignment   = NSTextAlignmentCenter;
    [v_tutoriel addSubview:tv_explaination];
    
    return v_tutoriel;
}


@end








