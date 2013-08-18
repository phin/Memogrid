//
//  MGViewController.h
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-02-17.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSquare.h"
#import "MGLevelManager.h"

@interface MGViewController : UIViewController <UIAlertViewDelegate> {
    
    // Logic elements
    BOOL canPlay;
    BOOL debugMode;
    NSMutableArray *a_currentGame;
    MGLevelManager *mg_level;
    
    // UI Elements
    MGSquare *mg_square;
    
    // Storyboard
    IBOutlet UIButton *b_newgame; // Debug
    IBOutlet UILabel  *l_currentlvl;
    IBOutlet MGButton *b_ready;
}

- (void) failedGame;
- (void) succeededGame;

@end
