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

+ (void)init {
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: [self getPlistPath]]) {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Levels" ofType:@"plist"]; //5
        [fileManager copyItemAtPath:bundle toPath: [self getPlistPath] error:&error]; //6
    }
}

+ (NSString *)getPlistPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Levels.plist"];
    return path;
}

+ (NSArray *)getLevelsForMode:(GameMode)mode {

    NSMutableDictionary *d_all_levels = [[NSMutableDictionary alloc] initWithContentsOfFile:[self getPlistPath]];
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
    // Find the first level that we didn't completed.
    for (int i = 0; i < [a_mode_levels count]; i++) {
        if ([[[a_mode_levels objectAtIndex:i] objectForKey:@"completed"] intValue] == 1) {
            level++;
        }
    }
    NSLog(@"Level %i", level);
    return level;
}

+ (void)userFinishedLevel:(int)level forMode:(GameMode)mode {

    // Set the finished level as done
    NSString *path                 = [[NSBundle mainBundle] pathForResource:@"Levels" ofType:@"plist"];
    NSMutableDictionary* d_levels  = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    NSArray* a_current_mode        = (NSArray*)[d_levels valueForKey: [self modeToString:mode]];
    NSMutableDictionary *d_current = [a_current_mode objectAtIndex:level-1];
    //[d_current setObject:[NSInteg] forKey:@"completed"];
    //[d_levels writeToFile: path atomically:YES];
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
