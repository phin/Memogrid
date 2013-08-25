//
//  UIViewController+MGBase.h
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-08-17.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <AudioToolbox/AudioToolbox.h>

@interface UIViewController (MGBase)

- (void) actionShareOnFacebook:(NSString *)fb_string;
- (void) actionShareOnTwitter:(NSString *)tw_string;

- (void)playSound:(NSString *)fName ofType:(NSString *)ext;

- (void) presentModalViewController:(UIViewController *)modalViewController withPushDirection: (NSString *) direction;
- (void) dismissModalViewControllerWithPushDirection:(NSString *) direction;


@end
