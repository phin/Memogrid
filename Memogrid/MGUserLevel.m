//
//  MGUserLevel.m
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-04-14.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "MGUserLevel.h"

// Singleton Class

@implementation MGUserLevel

// Get the shared instance and create it if necessary.
+ (MGUserLevel *)sharedInstance {
    static MGUserLevel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{    
    if (self = [super init])
    {
        self.current_mode  = Classic; // TODO Get from last played.
        self.current_level = [MGLevelManager getUserCurrentLevelForMode:self.current_mode];
    }
    
    return self;
}

- (void) setCurrentLevel:(int)level forMode:(GameMode)mode
{
    self.current_level = level;
    self.current_mode  = mode;
}

@end
