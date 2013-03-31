//
//  MGMenuViewController.m
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-02-28.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "MGMenuViewController.h"
#import "MGViewController.h"

@interface MGMenuViewController ()

@end

@implementation MGMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - INIT

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initUI];
    [self initLevels];
}

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self animationPopFrontScaleUp];
}

- (void) initUI {
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    // Background
    noiseBackView = [[KGNoiseLinearGradientView alloc] initWithFrame:self.view.bounds];
    noiseBackView.backgroundColor = [UIColor colorWithRed:237./255. green:231./255. blue:224./255. alpha:1.000];
    noiseBackView.noiseBlendMode = kCGBlendModeMultiply;
    noiseBackView.noiseOpacity = 0.05;
    [self.view insertSubview:noiseBackView atIndex:0];
}

- (void) initLevels {
    
    pv_levels = [[PagedFlowView alloc] initWithFrame:CGRectMake(0, 75, 320, 300)];
    pv_levels.delegate         = self;
    pv_levels.dataSource       = self;
    pv_levels.minimumPageAlpha = 1.0;
    pv_levels.minimumPageScale = 1.0;
    pv_levels.pageControl      = pc_levels;
    [self.view addSubview:pv_levels];
}


#pragma mark - GAME FLOW FUNCTIONS

- (IBAction)backToGame:(id)sender {
    id p;
    for (p = [self presentingViewController]; p && [p class] != [MGViewController class]; p = [p presentingViewController]);
    /* Empty for body */
    [p dismissModalViewControllerAnimated:NO];
}

#pragma mark - PagedFlowView Delegate

- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView {
    return CGSizeMake(320, (IS_IPHONE_5) ? 300 : 150);
}

- (void)didChangePageToIndex:(int)index forFlowView:(PagedFlowView *)flowView {
    NSLog(@"didChangePageToIndex: %i forFlowView:%i", index, flowView.tag);
}




#pragma mark - PagedFlowView Datasource

- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView {
    return 3;
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    // DEBUG
    NSArray *a_colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor blueColor], nil];
    
    UIView *v_tutoriel = (UIView *)[flowView dequeueReusableCell];
    if (!v_tutoriel) {
        v_tutoriel = [[UIView alloc] init];
    }
    v_tutoriel.backgroundColor = [a_colors objectAtIndex:index];
    return v_tutoriel;
}


#pragma mark - UNLOAD


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
