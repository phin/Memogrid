//
//  MGLevelManager.m
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-03-02.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "MGLevelManager.h"

@implementation MGLevelManager

// General
+ (NSArray *)getLevelsForMode:(GameMode)mode {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Levels" ofType:@"plist"];
    NSMutableDictionary *d_all_levels = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSMutableArray *a_mode_levels = [NSArray arrayWithArray:[d_all_levels objectForKey:[self modeToString:mode]]];
    return a_mode_levels;
}

+ (int)getTotalLevelsForMode:(GameMode)mode {
    NSArray *a_mode_levels = [self getLevelsForMode:mode];
    int total = [a_mode_levels count];
    return total;
}

+ (int)getDifficultyFromLevel:(int)level andMode:(GameMode)mode {
    int difficulty = 0;
    NSArray *a_mode_levels = [self getLevelsForMode:mode];
    int currentUserLevel   = [self userCurrentLevelForMode:mode];
    difficulty = [[[a_mode_levels objectAtIndex:currentUserLevel] objectForKey:@"difficulty"] intValue];
    NSLog(@"Difficulty: %i", difficulty);
    return difficulty;
}

// User related
+ (int)userCurrentLevelForMode:(GameMode)mode {
    int level = 1;
    NSArray *a_mode_levels = [self getLevelsForMode:mode];
    // Find the first level that we didn't completed. TOFIX: For some reason, while is not working properly
    for (int i = 0; i < [a_mode_levels count]; i++) {
        if ([[[a_mode_levels objectAtIndex:i] objectForKey:@"completed"] intValue] == 1) {
            level++;
        }
    }
    NSLog(@"Level %i", level);
    return level;
}
+ (BOOL)didUserFinishedLevel:(int)level forMode:(GameMode)mode {
    BOOL finishedLevel = false;
    // TODO
    
    return finishedLevel;
}


// Useful Internally

+ (NSString*)modeToString:(GameMode)mode {
    NSString *result = nil;
    
    switch(mode) {
        case Classic:
            result = @"Classic";
            break;
        case Bicolor:
            result = @"Bicolor";
            break;
        case Simon:
            result = @"Simon";
            break;
        default:
            result = @"Classic";
    }
    
    return result;
}


@end
