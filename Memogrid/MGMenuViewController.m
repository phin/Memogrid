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
#import "MGUserLevel.h"

@interface MGMenuViewController ()

@end

@implementation MGMenuViewController

@synthesize a_classic;


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

#pragma mark - PagedFlowView Datasource

- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView {
    return 2;
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    UIView *v_tutoriel = (UIView *)[flowView dequeueReusableCell];
    if (!v_tutoriel) {
        v_tutoriel = [[UIView alloc] init];
    }

    if (index == 0) {
        v_tutoriel = [self levelViewForMode:@"Classic"];

    } else if (index == 1) {
        v_tutoriel = [self levelViewForMode:@"Sequence"];
    }
    
    return v_tutoriel;
}

- (UIView *)levelViewForMode:(NSString *)mode {
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
    
    UICollectionView *cv_levels = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 25, 320, 320) collectionViewLayout:flowLayout];
    cv_levels.dataSource = self;
    cv_levels.delegate   = self;
    cv_levels.backgroundColor = [UIColor clearColor];
    
    if ([mode isEqualToString:@"Classic"]) {
        cv_levels.tag = 111;
        label.text     = @"CLASSIC";
    } else if ([mode isEqualToString:@"Sequence"]) {
        cv_levels.tag = 222;
        label.text     = @"SEQUENCE";
    }
    
    [cv_levels registerClass:[CVCell class] forCellWithReuseIdentifier:@"cvCell"];
    [v addSubview:cv_levels];
    
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
    
    GameMode gm_current = Classic;
    [cell setMode:@"Classic"];
    
    if (collectionView.tag == 222) {
        [cell setMode:@"Sequence"];
        gm_current = Simon;
    }
    
    // Check if that level is accessible
    if ([MGLevelManager userFinishedLevel:indexPath.row forMode:gm_current]) {
        [cell setCanBePlayed:YES];
        [cell setCompleted:YES];
    } else if (indexPath.row == [MGLevelManager getUserCurrentLevelForMode:gm_current]) {
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GameMode gm_current = Classic;
    NSString *s_mode    = @"Classic";
    
    if (collectionView.tag == 222)
    {
        gm_current = Simon;
        s_mode     = @"Sequence";
    }
    
    if ([MGLevelManager canPlayLevelAtIndex:indexPath.row forMode:gm_current])
    {
        [[MGUserLevel sharedInstance] setCurrentLevel: indexPath.row forMode:gm_current];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSLog(@"User cannot access this level.");
    }
}


@end
