//
//  MGButton.m
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-03-23.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "MGButton.h"

#define kDiff 3
#define kDiff2 1.35

@implementation MGButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    [self initialize];
}

- (void)initialize {
    
    // Frame
    self.backgroundColor = [UIColor colorWithRed: 0.598 green: 0.525 blue: 0.458 alpha: 0.2];
        
    // Label
    self.titleLabel.font = [UIFont fontWithName:@"VerbBlack" size:24];
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.titleLabel.shadowColor  = [UIColor darkGrayColor];
    self.titleLabel.shadowOffset = CGSizeMake(0.0, 2.0);
    
    // Border
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 2.0f;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
        fadeOutAnimation.duration = 0.1f;
        fadeOutAnimation.removedOnCompletion = NO;
        fadeOutAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
        fadeOutAnimation.fillMode = kCAFillModeForwards;
        fadeOutAnimation.toValue = [NSNumber numberWithFloat:4.0f];
        [self.layer addAnimation:fadeOutAnimation forKey:@"animateOpacity"];
    } else {
        CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
        fadeOutAnimation.duration = 0.1f;
        fadeOutAnimation.removedOnCompletion = NO;
        fadeOutAnimation.fromValue = [NSNumber numberWithFloat:4.0f];
        fadeOutAnimation.fillMode = kCAFillModeForwards;
        fadeOutAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        [self.layer addAnimation:fadeOutAnimation forKey:@"animateOpacity"];

    }
}

@end
