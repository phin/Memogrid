//
//  UIViewController+BlurryModal.h
//  BlurryModal
//
//  Created by Joshua Tessier on 2013-09-24.
//  Copyright (c) 2013 Joshua Tessier. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JTCompletionBlock)(void);

@protocol JTBlurryModal <NSObject>
- (CGSize)sizeWhenPresentedModally;
@end

@interface UIViewController (BlurryModal)

#pragma mark - Modal Display

- (void)pushModalViewController:(UIViewController*)controller;
- (void)pushModalViewController:(UIViewController*)controller animated:(BOOL)animated;

/**
 * Adds a modal view controller onto the stack. It will cause blurring all around it.
 * Animating will cause the blurring / view to fade in.
 */
- (void)pushModalViewController:(UIViewController*)controller animated:(BOOL)animated completion:(JTCompletionBlock)completion;

#pragma mark - Modal Dismissal

- (void)popModalViewController;
- (void)popModalViewController:(BOOL)animated;

/**
 * Removes the last (if any) view controller to be pushed onto the modal stack.
 * Animating will cause the blurring / view to fade out.
 */
- (void)popModalViewController:(BOOL)animated completion:(JTCompletionBlock)completion;

@end
