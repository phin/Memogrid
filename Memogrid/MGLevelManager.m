//
//  MGLevelManager.m
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-03-02.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "MGLevelManager.h"

@implementation MGLevelManager


#pragma mark - Init

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

#pragma mark - Getters

+ (NSArray *)getLevelsForMode:(GameMode)mode {
        
    NSMutableDictionary *d_all_levels = [[NSMutableDictionary alloc] initWithContentsOfFile:[self getPlistPath]];
    NSMutableArray *a_mode_levels = [NSMutableArray arrayWithArray:[d_all_levels objectForKey:[self modeToString:mode]]];
    return a_mode_levels;
}

+ (int)getTotalLevelsForMode:(GameMode)mode {
    NSArray *a_mode_levels = [self getLevelsForMode:mode];
    int total = (int)[a_mode_levels count];
    return total;
}

+ (int)getDifficultyFromLevel:(int)level andMode:(GameMode)mode {

    NSArray *a_mode_levels = [self getLevelsForMode:mode];
    if (!level) {
        //level = [self getUserCurrentLevelForMode:mode];
    }
    if (level >= 24) {
        level = 24;
    }
    int difficulty = [[[a_mode_levels objectAtIndex:level] objectForKey:@"difficulty"] intValue];
    NSLog(@"Difficulty: %i ForLevel: %i", difficulty, level);
    return difficulty;
}

+ (BOOL)finishedGameMode:(GameMode)mode {
    
    int i_usr = [self getUserCurrentLevelForMode:mode]; // starts at 0 to 24 (Classic)
    int i_max = (int)[[self getLevelsForMode:mode] count];   // 25 (Classic)

    return (i_usr+1 == i_max) ? YES : NO;
}

+ (BOOL)canPlayLevelAtIndex:(int)index forMode:(GameMode)mode {
    if ([self userFinishedLevel:index forMode:mode]) {
        return YES;
    } else if (([self getUserCurrentLevelForMode:mode]) == index) {
        // Current level the user is trying to achieve.
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - User

+ (int)getUserCurrentLevelForMode:(GameMode)mode {
    
    int level = 0;
    NSArray *a_mode_levels = [self getLevelsForMode:mode];
    
    // Find the first level that we didn't completed.
    for (int i = 0; i < [a_mode_levels count]; i++) {
        if ([[[a_mode_levels objectAtIndex:i] objectForKey:@"completed"] intValue] == 1) {
            level++;
        }
    }
    if (level > 24) {level = 24;}
    //NSLog(@"Level %i", level);
    return level;
}

+ (BOOL)userFinishedLevel:(int)level forMode:(GameMode)mode
{
    if (level > 24) {level = 24;}
    // Get if the user has finished a spcific level already
    NSArray *a_mode_levels = [self getLevelsForMode:mode];
    return [[[a_mode_levels objectAtIndex:level] objectForKey:@"completed"] boolValue];
}


#pragma mark - Setters

+ (void)setUserFinishedLevel:(int)level forMode:(GameMode)mode
{
    if (level > 24) {level = 24;}
    
    // Set the finished level as done
    NSString *path                 = [self getPlistPath];
    NSMutableDictionary* d_levels  = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    NSArray* a_current_mode        = (NSArray*)[d_levels valueForKey: [self modeToString:mode]];
    NSMutableDictionary *d_current = [a_current_mode objectAtIndex:level];
    [d_current setObject:[NSNumber numberWithBool:YES] forKey:@"completed"];
    [d_levels writeToFile: path atomically:YES];
}


#pragma mark - Helpers

+ (NSString*)modeToString:(GameMode)mode {
    NSString *result = nil;
    
    switch(mode) {
        case Classic:
            result = @"Classic";
            break;
        case Sequence:
            result = @"Sequence";
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
