//
//  MGUserLevel.h
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-04-14.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGLevelManager.h"

@interface MGUserLevel : NSObject

+ (id)sharedInstance;
- (void)setCurrentLevel:(int)level forMode:(GameMode)mode;

@property (nonatomic, assign) int current_level;
@property (nonatomic, assign) GameMode current_mode;

@end
