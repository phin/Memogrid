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
    [self setBackgroundColor:[UIColor clearColor]];
    
    // ALWAYS 250 x 55
    
    // Label
    self.titleLabel.font = [UIFont fontWithName:@"VerbBlack" size:22];
    self.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 0, 0);
    self.titleLabel.shadowColor = [UIColor blackColor];
    self.titleLabel.shadowOffset = CGSizeMake(0.0, 2.0);
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleShadowColor:[UIColor blackColor] forState:UIControlStateHighlighted];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    // Redraw with an highlighted state
    self.titleEdgeInsets = UIEdgeInsetsMake(highlighted ? 6 : -2, 0, 0, 0);
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (self.isHighlighted) {
        //// General Declarations
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* rectangleArrondi2ColorOverlay = [UIColor colorWithRed: 0.598 green: 0.525 blue: 0.458 alpha: 1];
        UIColor* rectangleArrondi2 = [UIColor colorWithRed: 0.714 green: 0.016 blue: 0 alpha: 1];
        UIColor* rectangleArrondi2InnerShadowColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.4];
        
        //// Shadow Declarations
        UIColor* rectangleArrondi2InnerShadow = rectangleArrondi2InnerShadowColor;
        CGSize rectangleArrondi2InnerShadowOffset = CGSizeMake(0.1, -0.1);
        CGFloat rectangleArrondi2InnerShadowBlurRadius = 8;
        
        //// Group 2
        {
            //// Rectangle arrondi 2 Drawing
            UIBezierPath* rectangleArrondi2Path = [UIBezierPath bezierPath];
            [rectangleArrondi2Path moveToPoint: CGPointMake(3.06, 4)];
            [rectangleArrondi2Path addLineToPoint: CGPointMake(246.94, 4)];
            [rectangleArrondi2Path addCurveToPoint: CGPointMake(rect.size.width, 7) controlPoint1: CGPointMake(248.63, 4) controlPoint2: CGPointMake(rect.size.width, 5.34)];
            [rectangleArrondi2Path addLineToPoint: CGPointMake(rect.size.width, 51)];
            [rectangleArrondi2Path addCurveToPoint: CGPointMake(246.94, 54) controlPoint1: CGPointMake(rect.size.width, 52.66) controlPoint2: CGPointMake(248.63, 54)];
            [rectangleArrondi2Path addLineToPoint: CGPointMake(3.06, 54)];
            [rectangleArrondi2Path addCurveToPoint: CGPointMake(0, 51) controlPoint1: CGPointMake(1.37, 54) controlPoint2: CGPointMake(0, 52.66)];
            [rectangleArrondi2Path addLineToPoint: CGPointMake(0, 7)];
            [rectangleArrondi2Path addCurveToPoint: CGPointMake(3.06, 4) controlPoint1: CGPointMake(0, 5.34) controlPoint2: CGPointMake(1.37, 4)];
            [rectangleArrondi2Path closePath];
            [rectangleArrondi2 setFill];
            [rectangleArrondi2Path fill];
            
            
            //// Rectangle arrondi 2 ColorOverlay Drawing
            UIBezierPath* rectangleArrondi2ColorOverlayPath = [UIBezierPath bezierPath];
            [rectangleArrondi2ColorOverlayPath moveToPoint: CGPointMake(3.06, 4)];
            [rectangleArrondi2ColorOverlayPath addLineToPoint: CGPointMake(246.94, 4)];
            [rectangleArrondi2ColorOverlayPath addCurveToPoint: CGPointMake(rect.size.width, 7) controlPoint1: CGPointMake(248.63, 4) controlPoint2: CGPointMake(rect.size.width, 5.34)];
            [rectangleArrondi2ColorOverlayPath addLineToPoint: CGPointMake(rect.size.width, 51)];
            [rectangleArrondi2ColorOverlayPath addCurveToPoint: CGPointMake(246.94, 54) controlPoint1: CGPointMake(rect.size.width, 52.66) controlPoint2: CGPointMake(248.63, 54)];
            [rectangleArrondi2ColorOverlayPath addLineToPoint: CGPointMake(3.06, 54)];
            [rectangleArrondi2ColorOverlayPath addCurveToPoint: CGPointMake(0, 51) controlPoint1: CGPointMake(1.37, 54) controlPoint2: CGPointMake(0, 52.66)];
            [rectangleArrondi2ColorOverlayPath addLineToPoint: CGPointMake(0, 7)];
            [rectangleArrondi2ColorOverlayPath addCurveToPoint: CGPointMake(3.06, 4) controlPoint1: CGPointMake(0, 5.34) controlPoint2: CGPointMake(1.37, 4)];
            [rectangleArrondi2ColorOverlayPath closePath];
            [rectangleArrondi2ColorOverlay setFill];
            [rectangleArrondi2ColorOverlayPath fill];
            
            ////// Rectangle arrondi 2 ColorOverlay Inner Shadow
            CGRect rectangleArrondi2ColorOverlayBorderRect = CGRectInset([rectangleArrondi2ColorOverlayPath bounds], -rectangleArrondi2InnerShadowBlurRadius, -rectangleArrondi2InnerShadowBlurRadius);
            rectangleArrondi2ColorOverlayBorderRect = CGRectOffset(rectangleArrondi2ColorOverlayBorderRect, -rectangleArrondi2InnerShadowOffset.width, -rectangleArrondi2InnerShadowOffset.height);
            rectangleArrondi2ColorOverlayBorderRect = CGRectInset(CGRectUnion(rectangleArrondi2ColorOverlayBorderRect, [rectangleArrondi2ColorOverlayPath bounds]), -1, -1);
            
            UIBezierPath* rectangleArrondi2ColorOverlayNegativePath = [UIBezierPath bezierPathWithRect: rectangleArrondi2ColorOverlayBorderRect];
            [rectangleArrondi2ColorOverlayNegativePath appendPath: rectangleArrondi2ColorOverlayPath];
            rectangleArrondi2ColorOverlayNegativePath.usesEvenOddFillRule = YES;
            
            CGContextSaveGState(context);
            {
                CGFloat xOffset = rectangleArrondi2InnerShadowOffset.width + round(rectangleArrondi2ColorOverlayBorderRect.size.width);
                CGFloat yOffset = rectangleArrondi2InnerShadowOffset.height;
                CGContextSetShadowWithColor(context,
                                            CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                            rectangleArrondi2InnerShadowBlurRadius,
                                            rectangleArrondi2InnerShadow.CGColor);
                
                [rectangleArrondi2ColorOverlayPath addClip];
                CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(rectangleArrondi2ColorOverlayBorderRect.size.width), 0);
                [rectangleArrondi2ColorOverlayNegativePath applyTransform: transform];
                [[UIColor grayColor] setFill];
                [rectangleArrondi2ColorOverlayNegativePath fill];
            }
            CGContextRestoreGState(context);
            
        }

    } else {
        // Drawing code
        //// General Declarations
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        
        UIColor* rectangleArrondi2ColorOverlay = [UIColor colorWithRed: 0.598 green: 0.525 blue: 0.458 alpha: 1];
        UIColor* rectangleArrondi2 = [UIColor colorWithRed: 0.714 green: 0.016 blue: 0 alpha: 1];
        UIColor* rectangleArrondi2DropShadowColor = [UIColor colorWithRed: 0.213 green: 0.185 blue: 0.177 alpha: 1];
        UIColor* rectangleArrondi2InnerShadowColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.4];
        
        UIColor* rectangleArrondi2DropShadow = rectangleArrondi2DropShadowColor;
        CGSize rectangleArrondi2DropShadowOffset = CGSizeMake(0.1, 4.1);
        CGFloat rectangleArrondi2DropShadowBlurRadius = 0;
        UIColor* rectangleArrondi2InnerShadow = rectangleArrondi2InnerShadowColor;
        CGSize rectangleArrondi2InnerShadowOffset = CGSizeMake(0.1, -0.1);
        CGFloat rectangleArrondi2InnerShadowBlurRadius = 8;
        
        //// Group 2
        {
            //// Rectangle arrondi 2 Drawing
            UIBezierPath* rectangleArrondi2Path = [UIBezierPath bezierPath];
            [rectangleArrondi2Path moveToPoint: CGPointMake(3.06, 0)];
            [rectangleArrondi2Path addLineToPoint: CGPointMake(246.94, 0)];
            [rectangleArrondi2Path addCurveToPoint: CGPointMake(rect.size.width, 3) controlPoint1: CGPointMake(248.63, 0) controlPoint2: CGPointMake(rect.size.width, 1.34)];
            [rectangleArrondi2Path addLineToPoint: CGPointMake(rect.size.width, 47)];
            [rectangleArrondi2Path addCurveToPoint: CGPointMake(246.94, 50) controlPoint1: CGPointMake(rect.size.width, 48.66) controlPoint2: CGPointMake(248.63, 50)];
            [rectangleArrondi2Path addLineToPoint: CGPointMake(3.06, 50)];
            [rectangleArrondi2Path addCurveToPoint: CGPointMake(0, 47) controlPoint1: CGPointMake(1.37, 50) controlPoint2: CGPointMake(0, 48.66)];
            [rectangleArrondi2Path addLineToPoint: CGPointMake(0, 3)];
            [rectangleArrondi2Path addCurveToPoint: CGPointMake(3.06, 0) controlPoint1: CGPointMake(0, 1.34) controlPoint2: CGPointMake(1.37, 0)];
            [rectangleArrondi2Path closePath];
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, rectangleArrondi2DropShadowOffset, rectangleArrondi2DropShadowBlurRadius, rectangleArrondi2DropShadow.CGColor);
            [rectangleArrondi2 setFill];
            [rectangleArrondi2Path fill];
            CGContextRestoreGState(context);
            
            
            
            //// Rectangle arrondi 2 ColorOverlay Drawing
            UIBezierPath* rectangleArrondi2ColorOverlayPath = [UIBezierPath bezierPath];
            [rectangleArrondi2ColorOverlayPath moveToPoint: CGPointMake(3.06, 0)];
            [rectangleArrondi2ColorOverlayPath addLineToPoint: CGPointMake(246.94, 0)];
            [rectangleArrondi2ColorOverlayPath addCurveToPoint: CGPointMake(rect.size.width, 3) controlPoint1: CGPointMake(248.63, 0) controlPoint2: CGPointMake(rect.size.width, 1.34)];
            [rectangleArrondi2ColorOverlayPath addLineToPoint: CGPointMake(rect.size.width, 47)];
            [rectangleArrondi2ColorOverlayPath addCurveToPoint: CGPointMake(246.94, 50) controlPoint1: CGPointMake(rect.size.width, 48.66) controlPoint2: CGPointMake(248.63, 50)];
            [rectangleArrondi2ColorOverlayPath addLineToPoint: CGPointMake(3.06, 50)];
            [rectangleArrondi2ColorOverlayPath addCurveToPoint: CGPointMake(0, 47) controlPoint1: CGPointMake(1.37, 50) controlPoint2: CGPointMake(0, 48.66)];
            [rectangleArrondi2ColorOverlayPath addLineToPoint: CGPointMake(0, 3)];
            [rectangleArrondi2ColorOverlayPath addCurveToPoint: CGPointMake(3.06, 0) controlPoint1: CGPointMake(0, 1.34) controlPoint2: CGPointMake(1.37, 0)];
            [rectangleArrondi2ColorOverlayPath closePath];
            [rectangleArrondi2ColorOverlay setFill];
            [rectangleArrondi2ColorOverlayPath fill];
            
            ////// Rectangle arrondi 2 ColorOverlay Inner Shadow
            CGRect rectangleArrondi2ColorOverlayBorderRect = CGRectInset([rectangleArrondi2ColorOverlayPath bounds], -rectangleArrondi2InnerShadowBlurRadius, -rectangleArrondi2InnerShadowBlurRadius);
            rectangleArrondi2ColorOverlayBorderRect = CGRectOffset(rectangleArrondi2ColorOverlayBorderRect, -rectangleArrondi2InnerShadowOffset.width, -rectangleArrondi2InnerShadowOffset.height);
            rectangleArrondi2ColorOverlayBorderRect = CGRectInset(CGRectUnion(rectangleArrondi2ColorOverlayBorderRect, [rectangleArrondi2ColorOverlayPath bounds]), -1, -1);
            
            UIBezierPath* rectangleArrondi2ColorOverlayNegativePath = [UIBezierPath bezierPathWithRect: rectangleArrondi2ColorOverlayBorderRect];
            [rectangleArrondi2ColorOverlayNegativePath appendPath: rectangleArrondi2ColorOverlayPath];
            rectangleArrondi2ColorOverlayNegativePath.usesEvenOddFillRule = YES;
            
            CGContextSaveGState(context);
            {
                CGFloat xOffset = rectangleArrondi2InnerShadowOffset.width + round(rectangleArrondi2ColorOverlayBorderRect.size.width);
                CGFloat yOffset = rectangleArrondi2InnerShadowOffset.height;
                CGContextSetShadowWithColor(context,
                                            CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                            rectangleArrondi2InnerShadowBlurRadius,
                                            rectangleArrondi2InnerShadow.CGColor);
                
                [rectangleArrondi2ColorOverlayPath addClip];
                CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(rectangleArrondi2ColorOverlayBorderRect.size.width), 0);
                [rectangleArrondi2ColorOverlayNegativePath applyTransform: transform];
                [[UIColor grayColor] setFill];
                [rectangleArrondi2ColorOverlayNegativePath fill];
            }
            CGContextRestoreGState(context);
            
        }
    }
}


@end
