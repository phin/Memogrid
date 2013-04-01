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

    NSString *s_path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    s_path = [s_path stringByAppendingPathComponent:@"Levels.plist"];
    
    // If the file doesn't exist in the Documents Folder, copy it.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:s_path]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"Levels" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:s_path error:nil];
    }
    
    return s_path;
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
    if (!level) {
        level = [self getUserCurrentLevelForMode:mode];
    }
    difficulty = [[[a_mode_levels objectAtIndex:level] objectForKey:@"difficulty"] intValue];
    NSLog(@"Difficulty: %i ForLevel: %i", difficulty, level);
    return difficulty;
}

+ (BOOL)finishedGameMode:(GameMode)mode {
    
    // Be sure that we don't have an exception going to the next level.
    int i_usr = [self getUserCurrentLevelForMode:mode];
    int i_max = [[self getLevelsForMode:mode] count];

    return (i_usr == i_max) ? YES : NO;
}

// User related
+ (int)getUserCurrentLevelForMode:(GameMode)mode {
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

+ (BOOL)userFinishedLevel:(int)level forMode:(GameMode)mode
{
    // Get if the user has finished a spcific level already
    NSArray *a_mode_levels = [self getLevelsForMode:mode];
    return [[[a_mode_levels objectAtIndex:level-1] objectForKey:@"completed"] boolValue];
}

// Setters

+ (void)setUserFinishedLevel:(int)level forMode:(GameMode)mode {

    // Set the finished level as done
    NSString *path                 = [self getPlistPath];
    NSMutableDictionary* d_levels  = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    NSArray* a_current_mode        = (NSArray*)[d_levels valueForKey: [self modeToString:mode]];
    NSMutableDictionary *d_current = [a_current_mode objectAtIndex:level-1];
    [d_current setObject:[NSNumber numberWithBool:YES] forKey:@"completed"];
    [d_levels writeToFile: path atomically:YES];
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
