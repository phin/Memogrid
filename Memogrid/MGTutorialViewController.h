//
//  MGTutorialViewController.h
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-03-02.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagedFlowView.h"

@interface MGTutorialViewController : UIViewController <PagedFlowViewDelegate, PagedFlowViewDataSource> {
    NSMutableArray *a_tutorials;
    KGNoiseLinearGradientView *noiseBackView;
}

@property (nonatomic, retain) IBOutlet PagedFlowView *pv_tutorial;
@property (nonatomic, retain) IBOutlet UIPageControl *pc_tutorial;

@end
