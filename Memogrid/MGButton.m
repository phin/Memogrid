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

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initialize];
}

- (void)initialize
{
    // Frame
    self.backgroundColor = [UIColor clearColor];
        
    // Label
    self.titleLabel.font = [UIFont fontWithName:@"VerbBlack" size:22];
    self.titleEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
    [self setTitleColor:C_LIGHT forState:UIControlStateNormal];
    [self setTitleColor:C_LIGHT forState:UIControlStateSelected];
    [self setTitleColor:C_LIGHT forState:UIControlStateHighlighted];
    [self setTitle:[NSString stringWithFormat:@"%@", self.titleLabel.text] forState:UIControlStateSelected]; // Hack to keep the color on iOS7
    [self setTitle:[NSString stringWithFormat:@"%@", self.titleLabel.text] forState:UIControlStateHighlighted]; // Hack to keep the color on iOS7
    
    // Border
    self.layer.borderColor = C_LIGHT_BACK.CGColor;
    self.layer.borderWidth = 2.0f;
    self.layer.cornerRadius = 2.0f;
    
}

#pragma mark - Animation

- (void) startBlinking
{
    // In case we call it twice by accident
    [self.layer removeAllAnimations];
    
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    fadeOutAnimation.duration               = 0.8f;
    fadeOutAnimation.removedOnCompletion    = NO;
    fadeOutAnimation.fromValue              = [NSNumber numberWithFloat:1.0f];
    fadeOutAnimation.fillMode               = kCAFillModeForwards;
    fadeOutAnimation.toValue                = [NSNumber numberWithFloat:4.0f];
    fadeOutAnimation.repeatCount            = HUGE_VALF;
    fadeOutAnimation.autoreverses           = YES;
    [self.layer addAnimation:fadeOutAnimation forKey:nil];
}
- (void) stopBlinking
{
    [self.layer removeAllAnimations];
}


#pragma mark - Touch Events

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
        fadeOutAnimation.duration = 0.1f;
        fadeOutAnimation.removedOnCompletion = NO;
        fadeOutAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
        fadeOutAnimation.fillMode = kCAFillModeForwards;
        fadeOutAnimation.toValue = [NSNumber numberWithFloat:6.0f];
        [self.layer addAnimation:fadeOutAnimation forKey:nil];
        
        self.alpha = 1.0f;
    } else {
        CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
        fadeOutAnimation.duration = 0.1f;
        fadeOutAnimation.removedOnCompletion = NO;
        fadeOutAnimation.fromValue = [NSNumber numberWithFloat:6.0f];
        fadeOutAnimation.fillMode = kCAFillModeForwards;
        fadeOutAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        [self.layer addAnimation:fadeOutAnimation forKey:nil];

    }
}

@end
