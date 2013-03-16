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
    
    pv_tutorial.delegate = self;
    pv_tutorial.dataSource = self;
    pv_tutorial.pageControl = pc_tutorial;
    pv_tutorial.minimumPageAlpha = 0.3;
    pv_tutorial.minimumPageScale = 0.9;
}


- (IBAction)goBackToGame:(id)sender {
    id p;
    for (p = [self presentingViewController]; p && [p class] != [MGViewController class]; p = [p presentingViewController]);
    /* Empty for body */
    [p dismissModalViewControllerAnimated:NO];
}

#pragma mark -
#pragma mark PagedFlowView Delegate

- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView {
    
    if (flowView.tag == 11) {
        return CGSizeMake(320, 355);
    } else {
        return CGSizeMake(115, 115);
    }
}

- (void)didChangePageToIndex:(int)index forFlowView:(PagedFlowView *)flowView {
    
    NSLog(@"didChangePageToIndex: %i forFlowView:%i", index, flowView.tag);
    
    if ((index == 0) && (flowView.tag == 11)) {
        b_pub.hidden = NO;
        rightArrow.hidden = NO;
    } else {
        b_pub.hidden = YES;
        rightArrow.hidden = YES;
    }
    
    if ([s_productName isEqualToString:@"CELLUDESTOCK"] &&
        (
         ((index == 1) && (flowView.tag == 11)) ||
         (flowView.tag == 22)
         )) {
            
            // Add the flow for the cellulite grades.
            [self.view addSubview:gradeFlowView];
            
            [self.view addSubview:l_grade];
            
            [self.view addSubview:i_squareProduct];
            
            [self.view bringSubviewToFront: super.pullUpView];
            
            if (flowView.tag == 22) {
                l_grade.text = [NSString stringWithFormat:@"GRADE %i", 5-index];
            }
            
            [UIView beginAnimations:@"cellulite" context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:self];
            [gradeFlowView setAlpha:1.0];
            [l_grade setAlpha:1.0];
            [i_squareProduct setAlpha:1.0];
            [UIView commitAnimations];
            
            NSLog(@"Show the cellulite flow.");
            
        } else {
            
            [UIView beginAnimations:@"cellulite" context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:self];
            [gradeFlowView setAlpha:0.0];
            [l_grade setAlpha:0.0];
            [i_squareProduct setAlpha:0.0];
            [UIView commitAnimations];
            
            if ([self.view.subviews containsObject:gradeFlowView]) {
                [gradeFlowView removeFromSuperview];
                [l_grade removeFromSuperview];
                [i_squareProduct removeFromSuperview];
            }
        }
}


#pragma mark -
#pragma mark PagedFlowView Datasource

- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView {
    return 4;
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    UIImageView *imageView = (UIImageView *)[flowView dequeueReusableCell];
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:index]];
    return imageView;
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
