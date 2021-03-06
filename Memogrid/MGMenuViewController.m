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

- (void) initUI {
    
    self.view.backgroundColor = C_BACK;
}

- (void) initLevels {
    
    [l_title setHidden:(!IS_IPHONE_5 && !IS_IPAD)];
    pv_levels = [[PagedFlowView alloc] initWithFrame:CGRectMake(0, (IS_IPHONE_5 || IS_IPAD) ? 52 : 5, 320 * SCALE, 345)];
    pv_levels.delegate         = self;
    pv_levels.dataSource       = self;
    pv_levels.minimumPageAlpha = 1.0;
    pv_levels.minimumPageScale = 1.0;
    pv_levels.pageControl      = pc_levels;
    [self.view addSubview:pv_levels];
    [self refreshiPadFrame];
    [pc_levels setHidden:IS_IPAD];
        
    NSMutableArray *secondSection = [[NSMutableArray alloc] init];
    for (int i = 0; i < 25; i++) {
        [secondSection addObject:[NSString stringWithFormat:@"item %d", i]];
    }
    a_classic = secondSection;
}

- (void)refreshiPadFrame {
    
    if (IS_IPAD) {
        float x = self.view.bounds.size.height/2 - pv_levels.frame.size.width/2;
        float y = 200.0;
        pv_levels.frame = CGRectMake(x, y, pv_levels.frame.size.width, pv_levels.frame.size.height);
    }
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self refreshiPadFrame];
}


#pragma mark - GAME FLOW FUNCTIONS

- (IBAction)backToGame:(id)sender {
    id p;
    for (p = [self presentingViewController]; p && [p class] != [MGViewController class]; p = [p presentingViewController]);
    /* Empty for body */
    [p dismissModalViewControllerWithPushDirection:kCATransitionFromBottom];
}

#pragma mark - PagedFlowView Delegate

- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView {
    return CGSizeMake(320 * SCALE, 345);
}

#pragma mark - PagedFlowView Datasource

- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView {
    return (IS_IPAD) ? 1 : 2;
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    if (IS_IPAD) {
        // Init views
        if (!v_classic) {
            v_classic = [self levelViewForMode:@"Classic"];
        }
        if (!v_sequence) {
            v_sequence = [self levelViewForMode:@"Sequence"];
        }
        
        // Only one page with the two UICollectionViews side by side
        UIView *v_levels = [[UIView alloc] init];
        [v_levels addSubview:v_classic];
        [v_levels addSubview:v_sequence];
        
        // Update frames
        v_sequence.frame = CGRectMake(320, v_sequence.frame.origin.y, v_sequence.frame.size.width, v_sequence.frame.size.height);
        
        return v_levels;
    } else {
        if (index == 0) {
            if (!v_classic) {
                v_classic = [self levelViewForMode:@"Classic"];
            }
            return v_classic;
        } else {
            if (!v_sequence) {
                v_sequence = [self levelViewForMode:@"Sequence"];
            }
            return v_sequence;
        }
    }
    
    return v_sequence; // will never be accessed.
}

- (UIView *)levelViewForMode:(NSString *)mode {
    
    UIView *v = [[UIView alloc] init];
    
    // Add a Label as Mode title
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor       = C_LIGHT;
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
        label.text     = NSLocalizedString(@"CLASSIC", nil);
    } else if ([mode isEqualToString:@"Sequence"]) {
        cv_levels.tag = 222;
        label.text     = NSLocalizedString(@"SEQUENCE", nil);
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
    [cell.titleLabel setText:[NSString stringWithFormat:@"%li",indexPath.row+1]];
    [cell setLevel:(int)indexPath.row+1];
    
    GameMode gm_current = Classic;
    [cell setMode:@"Classic"];
    
    if (collectionView.tag == 222) {
        [cell setMode:@"Sequence"];
        gm_current = Sequence;
    }
    
    // Check if that level is accessible
    if ([MGLevelManager userFinishedLevel:(int)indexPath.row forMode:gm_current]) {
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
        gm_current = Sequence;
        s_mode     = @"Sequence";
    }
    
    //NSDictionary *d_selected_level = @{ @"mode" : s_mode, @"level" : [NSString stringWithFormat:@"%i", indexPath.row] };
    //[PFAnalytics trackEvent:@"Menu - Selected Level" dimensions:d_selected_level];
    
    if ([MGLevelManager canPlayLevelAtIndex:(int)indexPath.row forMode:gm_current])
    {
        [[MGUserLevel sharedInstance] setCurrentLevel:(int)indexPath.row forMode:gm_current];
        [self dismissModalViewControllerWithPushDirection:kCATransitionFromBottom];
    } else {
        NSLog(@"User cannot access this level.");
    }
}


@end
