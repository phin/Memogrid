//
//  MGAppDelegate.h
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-02-17.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface MGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// currentPlayerID is the value of the playerID last time GameKit authenticated.
@property (retain,readwrite) NSString * currentPlayerID;

// isGameCenterAuthenticationComplete is set after authentication, and authenticateWithCompletionHandler's completionHandler block has been run. It is unset when the applicaiton is backgrounded.
@property (readwrite, getter=isGameCenterAuthenticationComplete) BOOL gameCenterAuthenticationComplete;


@end
