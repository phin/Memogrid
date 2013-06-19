//
//  MGMenuViewController.h
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-02-28.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagedFlowView.h"


@interface MGMenuViewController : UIViewController <PagedFlowViewDataSource, PagedFlowViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
        
    // Levels
    PagedFlowView *pv_levels;
    IBOutlet UIPageControl *pc_levels;
    IBOutlet UILabel       *l_title;
}

@property (nonatomic, strong) NSArray *a_classic;

- (IBAction)backToGame:(id)sender;

@end
