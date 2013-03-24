//
//  MGButtonSquare.m
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-03-23.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "MGButtonSquare.h"

@implementation MGButtonSquare

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
    
    // ALWAYS 50 x 53
    
    // Label
    self.titleLabel.font = [UIFont fontWithName:@"VerbBlack" size:22];
    self.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 0, 0);
    self.titleLabel.shadowColor = [UIColor blackColor];
    self.titleLabel.shadowOffset = CGSizeMake(0.0, 2.0);
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleShadowColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    // Image
    self.imageEdgeInsets = UIEdgeInsetsMake(-2, 0, 0, 0);
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    // Redraw with an highlighted state
    self.titleEdgeInsets = UIEdgeInsetsMake(highlighted ? 6 : -2, 0, 0, 0);
    self.imageEdgeInsets = UIEdgeInsetsMake(highlighted ? 6 : -2, 0, 0, 0);
    [self setNeedsDisplay];
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (self.isHighlighted) {
        //// General Declarations
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* b_squareColorOverlay = [UIColor colorWithRed: 0.598 green: 0.525 blue: 0.458 alpha: 1];
        UIColor* b_square = [UIColor colorWithRed: 0.6 green: 0.525 blue: 0.459 alpha: 1];
        UIColor* b_squareInnerShadowColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.4];
        
        //// Shadow Declarations
        UIColor* b_squareInnerShadow = b_squareInnerShadowColor;
        CGSize b_squareInnerShadowOffset = CGSizeMake(0.1, -0.1);
        CGFloat b_squareInnerShadowBlurRadius = 8;
        
        //// Group 2
        {
            //// b_square Drawing
            UIBezierPath* b_squarePath = [UIBezierPath bezierPath];
            [b_squarePath moveToPoint: CGPointMake(3.45, 3.34)];
            [b_squarePath addLineToPoint: CGPointMake(45.98, 3.34)];
            [b_squarePath addCurveToPoint: CGPointMake(49.43, 6.8) controlPoint1: CGPointMake(47.88, 3.34) controlPoint2: CGPointMake(49.43, 4.89)];
            [b_squarePath addLineToPoint: CGPointMake(49.43, 49.37)];
            [b_squarePath addCurveToPoint: CGPointMake(45.98, 52.82) controlPoint1: CGPointMake(49.43, 51.28) controlPoint2: CGPointMake(47.88, 52.82)];
            [b_squarePath addLineToPoint: CGPointMake(3.45, 52.82)];
            [b_squarePath addCurveToPoint: CGPointMake(0, 49.37) controlPoint1: CGPointMake(1.54, 52.82) controlPoint2: CGPointMake(0, 51.28)];
            [b_squarePath addLineToPoint: CGPointMake(0, 6.8)];
            [b_squarePath addCurveToPoint: CGPointMake(3.45, 3.34) controlPoint1: CGPointMake(0, 4.89) controlPoint2: CGPointMake(1.54, 3.34)];
            [b_squarePath closePath];
            [b_square setFill];
            [b_squarePath fill];
            
            
            //// b_square ColorOverlay Drawing
            UIBezierPath* b_squareColorOverlayPath = [UIBezierPath bezierPath];
            [b_squareColorOverlayPath moveToPoint: CGPointMake(3.45, 3.34)];
            [b_squareColorOverlayPath addLineToPoint: CGPointMake(45.98, 3.34)];
            [b_squareColorOverlayPath addCurveToPoint: CGPointMake(49.43, 6.8) controlPoint1: CGPointMake(47.88, 3.34) controlPoint2: CGPointMake(49.43, 4.89)];
            [b_squareColorOverlayPath addLineToPoint: CGPointMake(49.43, 49.37)];
            [b_squareColorOverlayPath addCurveToPoint: CGPointMake(45.98, 52.82) controlPoint1: CGPointMake(49.43, 51.28) controlPoint2: CGPointMake(47.88, 52.82)];
            [b_squareColorOverlayPath addLineToPoint: CGPointMake(3.45, 52.82)];
            [b_squareColorOverlayPath addCurveToPoint: CGPointMake(0, 49.37) controlPoint1: CGPointMake(1.54, 52.82) controlPoint2: CGPointMake(0, 51.28)];
            [b_squareColorOverlayPath addLineToPoint: CGPointMake(0, 6.8)];
            [b_squareColorOverlayPath addCurveToPoint: CGPointMake(3.45, 3.34) controlPoint1: CGPointMake(0, 4.89) controlPoint2: CGPointMake(1.54, 3.34)];
            [b_squareColorOverlayPath closePath];
            [b_squareColorOverlay setFill];
            [b_squareColorOverlayPath fill];
            
            ////// b_square ColorOverlay Inner Shadow
            CGRect b_squareColorOverlayBorderRect = CGRectInset([b_squareColorOverlayPath bounds], -b_squareInnerShadowBlurRadius, -b_squareInnerShadowBlurRadius);
            b_squareColorOverlayBorderRect = CGRectOffset(b_squareColorOverlayBorderRect, -b_squareInnerShadowOffset.width, -b_squareInnerShadowOffset.height);
            b_squareColorOverlayBorderRect = CGRectInset(CGRectUnion(b_squareColorOverlayBorderRect, [b_squareColorOverlayPath bounds]), -1, -1);
            
            UIBezierPath* b_squareColorOverlayNegativePath = [UIBezierPath bezierPathWithRect: b_squareColorOverlayBorderRect];
            [b_squareColorOverlayNegativePath appendPath: b_squareColorOverlayPath];
            b_squareColorOverlayNegativePath.usesEvenOddFillRule = YES;
            
            CGContextSaveGState(context);
            {
                CGFloat xOffset = b_squareInnerShadowOffset.width + round(b_squareColorOverlayBorderRect.size.width);
                CGFloat yOffset = b_squareInnerShadowOffset.height;
                CGContextSetShadowWithColor(context,
                                            CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                            b_squareInnerShadowBlurRadius,
                                            b_squareInnerShadow.CGColor);
                
                [b_squareColorOverlayPath addClip];
                CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(b_squareColorOverlayBorderRect.size.width), 0);
                [b_squareColorOverlayNegativePath applyTransform: transform];
                [[UIColor grayColor] setFill];
                [b_squareColorOverlayNegativePath fill];
            }
            CGContextRestoreGState(context);
            
        }
        
    } else {
        //// General Declarations
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* b_squareColorOverlay = [UIColor colorWithRed: 0.598 green: 0.525 blue: 0.458 alpha: 1];
        UIColor* b_square = [UIColor colorWithRed: 0.6 green: 0.525 blue: 0.459 alpha: 1];
        UIColor* b_squareDropShadowColor = [UIColor colorWithRed: 0.213 green: 0.185 blue: 0.177 alpha: 1];
        UIColor* b_squareInnerShadowColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.4];
        
        //// Shadow Declarations
        UIColor* b_squareDropShadow = b_squareDropShadowColor;
        CGSize b_squareDropShadowOffset = CGSizeMake(0.1, 3.1);
        CGFloat b_squareDropShadowBlurRadius = 0;
        UIColor* b_squareInnerShadow = b_squareInnerShadowColor;
        CGSize b_squareInnerShadowOffset = CGSizeMake(0.1, -0.1);
        CGFloat b_squareInnerShadowBlurRadius = 8;
        
        //// Group 2
        {
            //// b_square Drawing
            UIBezierPath* b_squarePath = [UIBezierPath bezierPath];
            [b_squarePath moveToPoint: CGPointMake(3.45, 0.34)];
            [b_squarePath addLineToPoint: CGPointMake(45.98, 0.34)];
            [b_squarePath addCurveToPoint: CGPointMake(49.43, 3.8) controlPoint1: CGPointMake(47.88, 0.34) controlPoint2: CGPointMake(49.43, 1.89)];
            [b_squarePath addLineToPoint: CGPointMake(49.43, 46.37)];
            [b_squarePath addCurveToPoint: CGPointMake(45.98, 49.82) controlPoint1: CGPointMake(49.43, 48.28) controlPoint2: CGPointMake(47.88, 49.82)];
            [b_squarePath addLineToPoint: CGPointMake(3.45, 49.82)];
            [b_squarePath addCurveToPoint: CGPointMake(0, 46.37) controlPoint1: CGPointMake(1.54, 49.82) controlPoint2: CGPointMake(0, 48.28)];
            [b_squarePath addLineToPoint: CGPointMake(0, 3.8)];
            [b_squarePath addCurveToPoint: CGPointMake(3.45, 0.34) controlPoint1: CGPointMake(0, 1.89) controlPoint2: CGPointMake(1.54, 0.34)];
            [b_squarePath closePath];
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, b_squareDropShadowOffset, b_squareDropShadowBlurRadius, b_squareDropShadow.CGColor);
            [b_square setFill];
            [b_squarePath fill];
            CGContextRestoreGState(context);
            
            
            
            //// b_square ColorOverlay Drawing
            UIBezierPath* b_squareColorOverlayPath = [UIBezierPath bezierPath];
            [b_squareColorOverlayPath moveToPoint: CGPointMake(3.45, 0.34)];
            [b_squareColorOverlayPath addLineToPoint: CGPointMake(45.98, 0.34)];
            [b_squareColorOverlayPath addCurveToPoint: CGPointMake(49.43, 3.8) controlPoint1: CGPointMake(47.88, 0.34) controlPoint2: CGPointMake(49.43, 1.89)];
            [b_squareColorOverlayPath addLineToPoint: CGPointMake(49.43, 46.37)];
            [b_squareColorOverlayPath addCurveToPoint: CGPointMake(45.98, 49.82) controlPoint1: CGPointMake(49.43, 48.28) controlPoint2: CGPointMake(47.88, 49.82)];
            [b_squareColorOverlayPath addLineToPoint: CGPointMake(3.45, 49.82)];
            [b_squareColorOverlayPath addCurveToPoint: CGPointMake(0, 46.37) controlPoint1: CGPointMake(1.54, 49.82) controlPoint2: CGPointMake(0, 48.28)];
            [b_squareColorOverlayPath addLineToPoint: CGPointMake(0, 3.8)];
            [b_squareColorOverlayPath addCurveToPoint: CGPointMake(3.45, 0.34) controlPoint1: CGPointMake(0, 1.89) controlPoint2: CGPointMake(1.54, 0.34)];
            [b_squareColorOverlayPath closePath];
            [b_squareColorOverlay setFill];
            [b_squareColorOverlayPath fill];
            
            ////// b_square ColorOverlay Inner Shadow
            CGRect b_squareColorOverlayBorderRect = CGRectInset([b_squareColorOverlayPath bounds], -b_squareInnerShadowBlurRadius, -b_squareInnerShadowBlurRadius);
            b_squareColorOverlayBorderRect = CGRectOffset(b_squareColorOverlayBorderRect, -b_squareInnerShadowOffset.width, -b_squareInnerShadowOffset.height);
            b_squareColorOverlayBorderRect = CGRectInset(CGRectUnion(b_squareColorOverlayBorderRect, [b_squareColorOverlayPath bounds]), -1, -1);
            
            UIBezierPath* b_squareColorOverlayNegativePath = [UIBezierPath bezierPathWithRect: b_squareColorOverlayBorderRect];
            [b_squareColorOverlayNegativePath appendPath: b_squareColorOverlayPath];
            b_squareColorOverlayNegativePath.usesEvenOddFillRule = YES;
            
            CGContextSaveGState(context);
            {
                CGFloat xOffset = b_squareInnerShadowOffset.width + round(b_squareColorOverlayBorderRect.size.width);
                CGFloat yOffset = b_squareInnerShadowOffset.height;
                CGContextSetShadowWithColor(context,
                                            CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                            b_squareInnerShadowBlurRadius,
                                            b_squareInnerShadow.CGColor);
                
                [b_squareColorOverlayPath addClip];
                CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(b_squareColorOverlayBorderRect.size.width), 0);
                [b_squareColorOverlayNegativePath applyTransform: transform];
                [[UIColor grayColor] setFill];
                [b_squareColorOverlayNegativePath fill];
            }
            CGContextRestoreGState(context);
            
        }
    }
}


@end
