//
//  UIViewController+MGBase.m
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-08-17.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import "UIViewController+MGBase.h"

@implementation UIViewController (MGBase)

#pragma mark - SHARING

- (void) actionShareOnFacebook:(NSString *)fb_string {
    SLComposeViewController *facebookPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [facebookPostVC setInitialText:fb_string];
    [self presentViewController:facebookPostVC animated:YES completion:nil];
}
- (void) actionShareOnTwitter:(NSString *)tw_string {
    SLComposeViewController *twitterPostVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [twitterPostVC setInitialText:tw_string];
    [self presentViewController:twitterPostVC animated:YES completion:nil];
}


#pragma mark - SOUND

- (void)playSound:(NSString *)fName ofType:(NSString *)ext
{
    BOOL playSound = [[NSUserDefaults standardUserDefaults] boolForKey:@"sound"];
    SystemSoundID *audioEffect = NULL;
    if (playSound) {
        NSString *path  = [[NSBundle mainBundle] pathForResource : fName ofType :ext];
        if ([[NSFileManager defaultManager] fileExistsAtPath : path])
        {
            NSURL *pathURL = [NSURL fileURLWithPath : path];
            AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef) pathURL, audioEffect);
            AudioServicesPlaySystemSound(*audioEffect);
        } else {
            NSLog(@"error, file not found: %@", path);
        }
    }
}

#pragma mark - TRANSITIONS

- (void) presentModalViewController:(UIViewController *)modalViewController withPushDirection: (NSString *) direction {
    
    [CATransaction begin];
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = direction;
    transition.duration = 0.3f;
    transition.fillMode = kCAFillModeForwards;
    transition.removedOnCompletion = YES;
    
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
    [self presentViewController:modalViewController animated:NO completion:nil];
    
    [CATransaction commit];
    
}

- (void) dismissModalViewControllerWithPushDirection:(NSString *) direction {
    
    [CATransaction begin];
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = direction;
    transition.duration = 0.3f;
    transition.fillMode = kCAFillModeForwards;
    transition.removedOnCompletion = YES;
    
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [CATransaction commit];
    
}


@end
