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
    Bicolor,
    Simon
} GameMode;

// General
+ (void)init;
+ (int)getTotalLevelsForMode:(GameMode)mode;
+ (int)getDifficultyFromLevel:(int)level andMode:(GameMode)mode;
+ (BOOL)finishedGameMode:(GameMode)mode;

// User related
+ (int)getUserCurrentLevelForMode:(GameMode)mode;
+ (void)setUserFinishedLevel:(int)level forMode:(GameMode)mode;

@end
