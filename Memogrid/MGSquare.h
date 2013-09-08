//
//  MGSquare.h
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-02-17.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGLevelManager.h"

#define ROWS 7
#define COLS 7
#define sq_SIZE ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 86 : 43)

enum colors {
    COLOR_DEFAULT,
    COLOR_RED,
    COLOR_ANSWER,
    COLOR_WHITE,
    COLOR_MAX
};

struct color_def
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
};

struct square {
    enum colors color;
    bool dirty;
};

@interface MGSquare : UIView {
    struct square status[ROWS][COLS];
    NSMutableArray *a_currentGame;
    NSMutableArray *a_remainingTiles;
}

@property (nonatomic) bool canPlay;
@property (nonatomic) bool multipleColors;

// Basic functions
- (void) setSquareWithColor:(enum colors)color forRow:(int)row andColumn:(int)column;
- (CGRect)makeRect:(int)column withRow:(int)row;
- (void)clear;

// Game
- (NSArray *)setGameWithDifficulty:(int)number andMode:(GameMode)mode;

- (void) showAnswer;

@end
