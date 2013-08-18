//
//  MGTransitionSegue.m
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-08-18.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "MGTransitionSegue.h"

@implementation MGTransitionSegue

-(void)perform {
    
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    
    [sourceViewController presentModalViewController:destinationController withPushDirection:kCATransitionFromTop];
}

@end
