//
//  MGMenuViewController.h
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-02-28.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagedFlowView.h"

@interface MGMenuViewController : UIViewController <PagedFlowViewDataSource, PagedFlowViewDelegate> {
    
    KGNoiseLinearGradientView *noiseBackView;
    
    // Levels
    PagedFlowView *pv_levels;
    IBOutlet UIPageControl *pc_levels;
}

- (IBAction)backToGame:(id)sender;

@end
