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

@interface MGViewController : UIViewController {
    
    // Logic elements
    BOOL canPlay;
    BOOL multipleColors;
    BOOL debugMode;
    BOOL forceLevel;
    
    NSMutableArray *a_currentGame;
    
    MGLevelManager * mg_level;
    
    // UI Elements
    MGSquare * mg_square;
    KGNoiseLinearGradientView *noiseBackView;
    
    // Storyboard
    IBOutlet UIButton *b_newgame; // Debug
    IBOutlet UILabel  *l_currentlvl;
}

- (void) failedGame;
- (void) succeededGame;
- (void) startLevel:(int)level forMode:(NSString *)mode;

@end
