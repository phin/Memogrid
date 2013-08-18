//
//  CVCell.m
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-03-31.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "CVCell.h"

@implementation CVCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CVCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
    }
    
    // Label
    self.titleLabel.font = [UIFont fontWithName:@"VerbBlack" size:22];
    self.titleLabel.shadowColor  = [UIColor blackColor];
    self.titleLabel.shadowOffset = CGSizeMake(0.0, 2.0);
    self.titleLabel.textColor    = [UIColor whiteColor];
    
    self.layer.cornerRadius = 2.0;
    self.backgroundColor = C_LIGHT;
    
    self.canBePlayed = NO;
    
    return self;
}

- (void) setMode:(NSString *)mode {
    
    if (!self.completed) {
        self.backgroundColor = C_LIGHT;
    }
}

- (void) setCompleted:(BOOL)completed {
    self.backgroundColor = (completed) ? C_GREEN : C_LIGHT;
}

- (void) setCanBePlayed:(BOOL)canBePlayed {
    if (!self.completed) {
        self.backgroundColor = (canBePlayed) ? [UIColor colorWithRed: 0.598 green: 0.525 blue: 0.458 alpha: 0.2] : [UIColor colorWithRed: 0.598 green: 0.525 blue: 0.458 alpha: 0.1];
    } else {
        self.backgroundColor = C_GREEN;
    }
}

@end
