//
//  MGViewController.h
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-02-17.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSquare.h"

@interface MGViewController : UIViewController {
    // Logic elements
    BOOL canPlay;
    BOOL multipleColors;
    BOOL debugMode;
    
    NSMutableArray *a_currentGame;
    
    // UI Elements
    MGSquare * mg_square;
}

- (void) failedGame;

@end
