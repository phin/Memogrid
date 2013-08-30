//
//  MGSquare.m
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-02-17.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "MGSquare.h"
#import "MGViewController.h"
#import "MGUserLevel.h"

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
                
                // Check current touched tile
                if (CGRectContainsPoint(ceRect, touchPoint)) {
                    
                    NSLog(@"Touched Square, row: %i col:%i", row, col);
                    
                    BOOL goodTile = NO;
                    
                    // TODO: Fails if the touch gets fired twice.
                    
                    // Check if what we selected is in the current game.
                    // Check if we are at least in a good row
                    NSArray *a_row = [a_currentGame objectAtIndex:0];
                    NSArray *a_col = [a_currentGame objectAtIndex:1];
                    
                    for (int r = 0; r < [a_row count]; r++) {
                        if ([[a_row objectAtIndex:r] intValue] == row) {
                            if ([[a_col objectAtIndex:r] intValue] == col) {
                                
                                
                                // SIMON / SEQUENCE MODE
                                
                                if ([[MGUserLevel sharedInstance] current_mode] == Simon) {
                                    // Is it the next one in the list that we need to type
                                    
                                    // 1. Loop to the next wanted value.
                                    int i_vals[2]; // To store the row and col.
                                    
                                    // Let's do a for loop since it's usually a small array.
                                    
                                    for (int i = 0; i < [[a_remainingTiles objectAtIndex:0] count]; i++) {
                                        if ([[[a_remainingTiles objectAtIndex:0] objectAtIndex:i] isEqualToString:@"99 Used"]) {
                                            // Keep going;
                                        } else {
                                            i_vals[0] = [[[a_remainingTiles objectAtIndex:0] objectAtIndex:i] intValue];
                                            i_vals[1] = [[[a_remainingTiles objectAtIndex:1] objectAtIndex:i] intValue];
                                            break;
                                        }
                                    }
                                    
                                    // 2. Compare the current values with the ones we need for this try.
                                    if ((i_vals[0] == row) && (i_vals[1] == col)) {
                                        NSLog(@"Sequence mode : Right Tile!");
                                    } else {
                                        NSLog(@"Sequence mode : Wrong tile.");
                                        goodTile = NO;
                                        [[self viewController] failedGame];
                                    }
                                }
                                
                                // CLASSIC
                                
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
                        // Show what we actually pressed
                        [self setSquareWithColor:COLOR_WHITE forRow:row andColumn:col];
                        
                        // Failed Game, show answers
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
    
    a_row = [self shuffleArray:a_row];
    a_col = [self shuffleArray:a_col];
    
    // Check if there is already an occurence of the pair
    if ([self similarPairsWithArray:a_row andArray:a_col]) {
        // Init new values. // IMPROVE, is not efficient
        return [self setGameWithDifficulty:n andMode:mode];
    }
    
    NSMutableArray *a_game_row = [NSMutableArray array];
    NSMutableArray *a_game_col = [NSMutableArray array];
    
    for (int i = 0; i < n; i++) {
        
        int rand_row = [[a_row objectAtIndex:i] intValue];
        int rand_col = [[a_col objectAtIndex:i] intValue];
        [a_game_row addObject:[NSString stringWithFormat:@"%i", rand_row]];
        [a_game_col addObject:[NSString stringWithFormat:@"%i", rand_col]];
        
        if ([[MGUserLevel sharedInstance] current_mode] == Simon) {
            [self performBlock:^{
                [self setSquareWithColor:COLOR_RED forRow:rand_row andColumn:rand_col];
            } afterDelay:0.4*i];
        } else {
            [self setSquareWithColor:COLOR_RED forRow:rand_row andColumn:rand_col];
        }
        
        NSLog(@"row:%i col:%i", rand_row, rand_col);
    }

    NSArray * game_values = [NSArray arrayWithObjects:a_game_row, a_game_col, nil];
    a_currentGame    = [game_values mutableCopy];
    a_remainingTiles = [game_values mutableCopy];

    return game_values;
}

#pragma mark - Game Helpers

-(int)getRandomNumber:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

-(int)getRandomNumber:(int)from to:(int)to excepted:(int)exception {
    int try = [self getRandomNumber:from to:to];
    if (try == exception) {
        return [self getRandomNumber:from to:to excepted:exception];
    } else {
        return try;
    }
}

- (BOOL) similarPairsWithArray:(NSArray *)array1 andArray:(NSArray*)array2
{
    // Ghetto but works.
    // Both need to be of equal length
    if ([array1 count] != [array2 count]) {
        return FALSE;
    }
    
    // Put the two arrays into strings
    // ex: 4 (array1), 2 array(2) would be 42, which cannot be found twice
    
    // 1. Create the strings array
    NSMutableArray *ma_pair_strings = [NSMutableArray array];
    for (int i = 0; i < [array1 count]; i++) {
        [ma_pair_strings addObject:[NSString stringWithFormat:@"%@%@", [array1 objectAtIndex:i], [array2 objectAtIndex:i]]];
    }
    
    // 2. Check if there is multiple occurences
 
    NSCountedSet *bag = [[NSCountedSet alloc] initWithArray:ma_pair_strings];
    for (NSString *s in bag) {
        if ([bag countForObject:s] > 1) {
            return FALSE; // there is more than one
        }
    }
    
    return TRUE;
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

- (void)performBlock:(void (^)(void))block
          afterDelay:(NSTimeInterval)delay
{
    block = [block copy];
    [self performSelector:@selector(fireBlockAfterDelay:)
               withObject:block
               afterDelay:delay];
}

- (void)fireBlockAfterDelay:(void (^)(void))block {
    block();
}


@end
