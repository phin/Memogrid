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

// User related
+ (int)userCurrentLevelForMode:(GameMode)mode;
+ (void)userFinishedLevel:(int)level forMode:(GameMode)mode;

// General
+ (void)init;
+ (int)getTotalLevelsForMode:(GameMode)mode;

@end
