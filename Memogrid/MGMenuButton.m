//
//  MGMenuButton.m
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-03-23.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "MGMenuButton.h"

@implementation MGMenuButton

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
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    // Redraw with an highlighted state
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* r_first;
    if ([self isHighlighted]) {
        //// Color Declarations Highlighted
        r_first = C_DEFAULT;
    } else {
        r_first = C_LIGHT;
    }
    
    //// Menu
    {
        //// r_first 2 Drawing
        UIBezierPath* r_first2Path = [UIBezierPath bezierPath];
        [r_first2Path moveToPoint: CGPointMake(0, 0)];
        [r_first2Path addLineToPoint: CGPointMake(rect.size.width, 0)];
        [r_first2Path addLineToPoint: CGPointMake(rect.size.width, 5)];
        [r_first2Path addLineToPoint: CGPointMake(0, 5)];
        [r_first2Path addLineToPoint: CGPointMake(0, 0)];
        [r_first2Path closePath];
        CGContextSaveGState(context);
        [r_first setFill];
        [r_first2Path fill];
        CGContextRestoreGState(context);

        //// r_second Drawing
        UIBezierPath* r_secondPath = [UIBezierPath bezierPath];
        [r_secondPath moveToPoint: CGPointMake(0, 11)];
        [r_secondPath addLineToPoint: CGPointMake(rect.size.width, 11)];
        [r_secondPath addLineToPoint: CGPointMake(rect.size.width, 16)];
        [r_secondPath addLineToPoint: CGPointMake(0, 16)];
        [r_secondPath addLineToPoint: CGPointMake(0, 11)];
        [r_secondPath closePath];
        CGContextSaveGState(context);
        [r_first setFill];
        [r_secondPath fill];
        CGContextRestoreGState(context);

        //// r_third Drawing
        UIBezierPath* r_thirdPath = [UIBezierPath bezierPath];
        [r_thirdPath moveToPoint: CGPointMake(0, 22)];
        [r_thirdPath addLineToPoint: CGPointMake(rect.size.width, 22)];
        [r_thirdPath addLineToPoint: CGPointMake(rect.size.width, 27)];
        [r_thirdPath addLineToPoint: CGPointMake(0, 27)];
        [r_thirdPath addLineToPoint: CGPointMake(0, 22)];
        [r_thirdPath closePath];
        CGContextSaveGState(context);
        [r_first setFill];
        [r_thirdPath fill];
        CGContextRestoreGState(context);
        
    }
}


@end
