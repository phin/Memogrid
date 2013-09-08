//
//  MGLevelManager.h
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-03-02.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGLevelManager : NSObject

// Game Modes
typedef enum {
    Classic,
    Sequence,
    Simon
} GameMode;

// General
// These classes are handling levels starting from 0.

+ (void)init;
+ (int)getTotalLevelsForMode:(GameMode)mode;
+ (int)getDifficultyFromLevel:(int)level andMode:(GameMode)mode;
+ (BOOL)finishedGameMode:(GameMode)mode;

+ (BOOL)canPlayLevelAtIndex:(int)index forMode:(GameMode)mode;

// User related

+ (int)getUserCurrentLevelForMode:(GameMode)mode; // Last non-completed level
+ (void)setUserFinishedLevel:(int)level forMode:(GameMode)mode;
+ (BOOL)userFinishedLevel:(int)level forMode:(GameMode)mode;


+ (NSString*)modeToString:(GameMode)mode;

@end
