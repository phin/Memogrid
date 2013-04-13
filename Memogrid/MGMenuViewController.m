//
//  MGMenuViewController.m
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-02-28.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "MGMenuViewController.h"
#import "MGViewController.h"
#import "CVCell.h"

@interface MGMenuViewController ()

@end

@implementation MGMenuViewController

@synthesize cv_classic;
@synthesize a_classic;

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
    
    [l_title setHidden:!IS_IPHONE_5];
    
    pv_levels = [[PagedFlowView alloc] initWithFrame:CGRectMake(0, (IS_IPHONE_5) ? 52 : 5, 320, 345)];
    pv_levels.delegate         = self;
    pv_levels.dataSource       = self;
    pv_levels.minimumPageAlpha = 1.0;
    pv_levels.minimumPageScale = 1.0;
    pv_levels.pageControl      = pc_levels;
    [self.view addSubview:pv_levels];
    
    // TODO : Show the current Mode the User is playing.
    
    NSMutableArray *secondSection = [[NSMutableArray alloc] init];
    for (int i = 0; i < 25; i++) {
        [secondSection addObject:[NSString stringWithFormat:@"item %d", i]];
    }
    a_classic = secondSection;
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
    return CGSizeMake(320, 345);
}

- (void)didChangePageToIndex:(int)index forFlowView:(PagedFlowView *)flowView {
    
}


#pragma mark - PagedFlowView Datasource

- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView {
    return 3;
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    UIView *v_tutoriel = (UIView *)[flowView dequeueReusableCell];
    if (!v_tutoriel) {
        v_tutoriel = [[UIView alloc] init];
    }

    if (index == 0) {
        v_tutoriel = [self levelsViewForMode:@"Classic"];

    } else if (index == 1) {
        v_tutoriel = [self levelsViewForMode:@"Bicolor"];
    } else {
        // Sequence
        v_tutoriel = [self levelsViewForMode:@"Sequence"];
    }
    
    return v_tutoriel;
}

- (UIView *)levelsViewForMode:(NSString *)mode {
    UIView *v = [[UIView alloc] init];
    
    // Add a Label as Mode title
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor       = [UIColor lightGrayColor];
    label.font            = [UIFont fontWithName:@"Futura-CondensedMedium" size:20];
    label.textAlignment   = NSTextAlignmentCenter;
    label.text            = mode; // Default
    [v addSubview:label];
    
    // Show the levels
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(50, 50)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    cv_classic = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 25, 320, 320) collectionViewLayout:flowLayout];
    cv_classic.dataSource = self;
    cv_classic.delegate   = self;
    cv_classic.backgroundColor = [UIColor clearColor];
    
    if ([mode isEqualToString:@"Classic"]) {
        cv_classic.tag = 111;
        label.text     = @"CLASSIC";
    } else if ([mode isEqualToString:@"Bicolor"]) {
        cv_classic.tag = 222;
        label.text     = @"BICOLOR";
    } else if ([mode isEqualToString:@"Sequence"]) {
        cv_classic.tag = 333;
        label.text     = @"SEQUENCE";
    }
    
    [cv_classic registerClass:[CVCell class] forCellWithReuseIdentifier:@"cvCell"];
    [v addSubview:cv_classic];
    
    return v;
}

#pragma mark - Grid Collection Views

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [a_classic count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cvCell";
    
    CVCell *cell = (CVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.titleLabel setText:[NSString stringWithFormat:@"%i",indexPath.row+1]];
    [cell setLevel:indexPath.row+1];
    
    // Set the right color
    if (collectionView.tag == 111) {
        [cell setMode:@"Classic"];
    } else if (collectionView.tag == 222) {
        [cell setMode:@"Bicolor"];
    } else if (collectionView.tag == 333) {
        [cell setMode:@"Sequence"];
    }
    
    // Check if that level is accessible
    
    if ([MGLevelManager userFinishedLevel:indexPath.row forMode:Classic]) {
        [cell setCanBePlayed:YES];
        [cell setCompleted:YES];
    } else if (indexPath.row == [MGLevelManager getUserCurrentLevelForMode:Classic]) {
        // Next level that the user needs to do
        [cell setCanBePlayed:YES];
    } else {
        [cell setCanBePlayed:NO];
    }
    
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


#pragma mark - UICollectionViewDelegate

- (void) collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Change background color
    CVCell *cell = (CVCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.canBePlayed) {
        cell.backgroundColor = [UIColor colorWithRed: 0.714 green: 0.016 blue: 0 alpha: 1];
    } else {
        NSLog(@"User cannot access this level.");
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([MGLevelManager canPlayLevelAtIndex:indexPath.row forMode:Classic]) {
        // Check if the user can access that level
        id dlg = self.delegate;
        [self dismissViewControllerAnimated:YES completion:nil];
        
        NSString *s_mode = @"Classic";
        
        if (collectionView.tag == 222) {
            s_mode = @"Bicolor";
        } else if (collectionView.tag == 333) {
            s_mode = @"Sequence";
        }
        
        if ([dlg respondsToSelector:@selector(startLevel:forMode:)]) {
            [dlg startLevel:indexPath.row forMode:s_mode];
        } else {
            NSLog(@"Unable to start Level");
        }
    }
}


#pragma mark - UNLOAD

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
