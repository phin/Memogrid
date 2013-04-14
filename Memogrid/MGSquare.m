//
//  MGSquare.m
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-02-17.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "MGSquare.h"
#import "MGViewController.h"

@implementation MGSquare

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        memset(status, 0, sizeof status);
        [self clear];
        a_currentGame    = [NSMutableArray array];
        a_remainingTiles = [NSMutableArray array];
    }
    return self;
}

- (MGViewController *)viewController {
    Class vcc = [MGViewController class];    // Called here to avoid calling it iteratively unnecessarily.
    UIResponder *responder = self;
    while ((responder = [responder nextResponder])) if ([responder isKindOfClass: vcc]) return (MGViewController *)responder;
    return nil;
}

- (CGRect)makeRect:(int)column withRow:(int)row {
    return CGRectMake(2*(row+1)+sq_SIZE*row, 2*(column+1) +sq_SIZE*column, sq_SIZE, sq_SIZE);
}

#pragma mark - Drawing

- (void)drawSquareAtRow:(int)row atColumn:(int)column {

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = [self makeRect:column withRow:row];
    
    rect = CGRectInset(rect, 1.0f, 1.0f);
    if (!context) {
        [self setNeedsDisplayInRect:rect];
        return;
    }
    
    /* Check what the color for this square should be */
    struct square *sq = &status[row][column];
    struct color_def *c = &color_values[sq->color];
    float radius = 2.0f;

    CGContextSetRGBFillColor(context, c->red, c->green, c->blue, c->alpha);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect));
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMinY(rect) + radius, radius, 3 * M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMaxY(rect) - radius, radius, 0, M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMaxY(rect) - radius, radius, M_PI / 2, M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect) + radius, radius, M_PI, 3 * M_PI / 2, 0);
    
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    sq->dirty = false;
}

- (void)drawRect:(CGRect)rect {
    
    int column, row;
    int startrow, startcol, endrow, endcol;
    
    startrow = (rect.origin.x - 2)/(sq_SIZE+2);
    startcol = (rect.origin.y - 2)/(sq_SIZE+2);
    
    if (startrow < 0) startrow = 0;
    if (startcol < 0) startcol = 0;
    
    endrow = ((rect.origin.x + rect.size.width) - 2)/(sq_SIZE+2);
    endcol = ((rect.origin.y + rect.size.height) - 2)/(sq_SIZE+2);
    
    if (endrow >= ROWS) endrow = ROWS-1;
    if (endcol >= COLS) endcol = COLS-1;
    
    for (row = startrow; row <= endrow; row++) {
        for (column = startcol; column <= endcol; column++) {
            [self drawSquareAtRow:row atColumn:column];
        }
    }
    
    //[KGNoise drawNoiseWithOpacity:0.05 andBlendMode:kCGBlendModeNormal];
}

- (void) setSquareWithColor:(enum colors)color forRow:(int)row andColumn:(int)column {
    assert(color >= 0 && color < COLOR_MAX && "That's not a color");
    assert(column >= 0 && column < COLS);
    assert(row >= 0 && row < ROWS);
    
    status[row][column].color = color;
    status[row][column].dirty = true;
    
    [self drawSquareAtRow:row atColumn:column];
}

#pragma mark - Touch Event

-(void)handleTouch:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_canPlay) {
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self];
        int row,col;
        for (row = 0; row < ROWS; row++) {
            for (col = 0; col < COLS; col++) {
                CGRect ceRect = [self makeRect:col withRow:row];
                
                // TODO : User feedback when tap on tile
                
                // Check current touched tile
                if (CGRectContainsPoint(ceRect, touchPoint)) {
                    
                    NSLog(@"Touched Square, row: %i col:%i", row, col);
                    
                    BOOL goodTile = NO;
                    
                    // Check if what we selected is in the current game.
                    // Check if we are at least in a good row
                    NSArray *a_row = [a_currentGame objectAtIndex:0];
                    NSArray *a_col = [a_currentGame objectAtIndex:1];
                    for (int r = 0; r < [a_row count]; r++) {
                        if ([[a_row objectAtIndex:r] intValue] == row) {
                            if ([[a_col objectAtIndex:r] intValue] == col) {
                                
                                // Since we use a string if the object has been used, it return 0 for the first row/col where the value is "Used".
                                // Easy fix would be to add 99.
                                
                                NSLog(@"Value : %@, %@", [[a_remainingTiles objectAtIndex:0] objectAtIndex:r],
                                      [[a_remainingTiles objectAtIndex:1] objectAtIndex:r]);
                                goodTile = YES;
                            
                                // Check if that tile is already removed from Remaining tile
                                if ([[[a_remainingTiles objectAtIndex:0] objectAtIndex:r] isEqualToString:@"99 Used"]) {
                                    // We have it already, let's move on.
                                    NSLog(@"Already typed");
                                    return;
                                } else {
                                    NSLog(@"Good tile");
                                    
                                    // Remove it from the remaining tiles.
                                    [[a_remainingTiles objectAtIndex:0] replaceObjectAtIndex:r withObject:@"99 Used"];
                                    [[a_remainingTiles objectAtIndex:1] replaceObjectAtIndex:r withObject:@"99 Used"];
                                }
                            }
                        }
                    }
                    
                    if (!goodTile) {
                        // Failed Game
                        [[self viewController] failedGame];
                        return;
                    }
                    
                    // Color the selected tile.
                    enum colors color = status[row][col].color;
                    if (color == COLOR_DEFAULT) {
                        color = COLOR_RED;
                    } else if (color == COLOR_RED && _multipleColors) {
                        color = COLOR_ANSWER;
                    } else if (color == COLOR_RED && !_multipleColors) {
                        color = COLOR_DEFAULT;
                    } else if (color == COLOR_ANSWER ) {
                        color = COLOR_DEFAULT;
                    }
                    [self setSquareWithColor:color forRow:row andColumn:col];
                    
                    
                    // Check if this was the last tile.
                    int tilesRemaining = [[a_remainingTiles objectAtIndex:0] count];
                    for (int i = 0; i < [[a_remainingTiles objectAtIndex:0] count]; i++) {
                        if ([[[a_remainingTiles objectAtIndex:0] objectAtIndex:i] isEqualToString:@"99 Used"]) {
                            tilesRemaining--;
                        }
                    }
                    NSLog(@"tilesRemaining:%i", tilesRemaining);
                    NSLog(@"Remaining Tile : %@", [a_remainingTiles objectAtIndex:0]);
                    if (tilesRemaining == 0) {
                        [[self viewController] succeededGame];
                    }
                    
                    return;
                }
            }
        }
    }
}

-(void)clear {
    int row,col;
    for (row = 0; row < ROWS; row++) {
        for (col = 0; col < COLS; col++) {
            [self setSquareWithColor:COLOR_DEFAULT forRow:row andColumn:col];
            // TODO Following is not working.
            status[row][col].color = COLOR_DEFAULT;
            status[row][col].dirty = true;
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouch:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouch:touches withEvent:event];
}


#pragma mark - Game Functions

- (void) showAnswer
{
    // Put all the tiles that are remaining in the remaing_tiles array.
    // NSLog(@"Remaining Tiles : %@", a_remainingTiles);
    
    for (int i = 0; i < [[a_remainingTiles objectAtIndex:0] count]; i++) {
        if (![[[a_remainingTiles objectAtIndex:0] objectAtIndex:i] isEqualToString:@"99 Used"]) {
            [self setSquareWithColor:COLOR_ANSWER forRow:[[[a_remainingTiles objectAtIndex:0] objectAtIndex:i] intValue] andColumn:[[[a_remainingTiles objectAtIndex:1] objectAtIndex:i] intValue]];
        }
    }
}

- (NSArray *)setGameWithDifficulty:(int)n andMode:(GameMode)mode {
    
    // Clear what's existing
    [self clear];
    
    // Generate n different numbers that can be in the table
    NSMutableArray *a_row = [NSMutableArray array];
    NSMutableArray *a_col = [NSMutableArray array];
        
    for (int i = 0; i < n; i++) {
        [a_row addObject:[NSString stringWithFormat:@"%i", [self getRandomNumber:0 to:(ROWS-1)]]];
        [a_col addObject:[NSString stringWithFormat:@"%i", [self getRandomNumber:0 to:(ROWS-1)]]];
    }
    
    // Not working.
    
    // TODO : Check that we have unique values.
    
    a_row = [self shuffleArray:a_row];
    a_col = [self shuffleArray:a_col];
    
    NSMutableArray *a_game_row = [NSMutableArray array];
    NSMutableArray *a_game_col = [NSMutableArray array];
    
    for (int i = 0; i < n; i++) {
        
        int rand_row = [[a_row objectAtIndex:i] intValue];
        int rand_col = [[a_col objectAtIndex:i] intValue];
        [a_game_row addObject:[NSString stringWithFormat:@"%i", rand_row]];
        [a_game_col addObject:[NSString stringWithFormat:@"%i", rand_col]];
        
        
        [self setSquareWithColor:COLOR_RED forRow:rand_row andColumn:rand_col];
        
        NSLog(@"row:%i col:%i", rand_row, rand_col);
    }

    NSArray * game_values = [NSArray arrayWithObjects:a_game_row, a_game_col, nil];
    a_currentGame    = [game_values mutableCopy];
    a_remainingTiles = [game_values mutableCopy];

    return game_values;
}

-(int)getRandomNumber:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

- (NSMutableArray *)shuffleArray:(NSArray *)array {
    NSMutableArray *ma_array = [NSMutableArray arrayWithArray:array];
    
    NSUInteger count = [ma_array count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [ma_array exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    return ma_array;
}

@end
