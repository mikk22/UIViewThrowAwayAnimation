//
//  RPLThrowAwayContainerView.h
//  ThrowAwayAnimationExample
//
//  Created by user on 21.08.14.
//  Copyright (c) 2014 RedPandazLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RPLThrowAwayAnimatedView.h"

@protocol RPLThrowAwayViewDatasource;
@protocol RPLThrowAwayViewDelegate;

@interface RPLThrowAwayContainerView : UIView

@property(nonatomic, weak) id<RPLThrowAwayViewDatasource> dataSource;
@property(nonatomic, weak) id<RPLThrowAwayViewDelegate> delegate;

@property(nonatomic, strong, readonly) UIView* backgroundView;

- (void)reloadData;
- (RPLThrowAwayAnimatedView*)dequeueReusableViewWithIdentifier:
    (NSString*)reuseIdentifier;

- (void)performThrowAwayAnimationWithDirection:
    (RPLThrowAwayAnimationDirection)animationDirection;
@end

@protocol RPLThrowAwayViewDatasource<NSObject>

- (RPLThrowAwayAnimatedView*)viewForThrowAwayView:
    (RPLThrowAwayContainerView*)throwAwayView;
- (CGRect)throwAwayView:(RPLThrowAwayContainerView*)throwAwayView
           frameForView:(RPLThrowAwayAnimatedView*)view;

@end

@protocol RPLThrowAwayViewDelegate<NSObject>

@optional
- (void)throwAwayContainerView:(RPLThrowAwayContainerView*)containerView
    animatedViewWillReturnToInitialPoint:
        (RPLThrowAwayAnimatedView*)animatedView;

- (void)throwAwayContainerView:(RPLThrowAwayContainerView*)containerView
    animatedViewDidReturnToInitialPoint:(RPLThrowAwayAnimatedView*)animatedView;

- (void)throwAwayContainerView:(RPLThrowAwayContainerView*)containerView
    animatedViewWillStartMovingAction:(RPLThrowAwayAnimatedView*)animatedView;

- (void)throwAwayContainerView:(RPLThrowAwayContainerView*)containerView
                           animatedView:(RPLThrowAwayAnimatedView*)animatedView
    willStartMovingAnimationToDirection:
        (RPLThrowAwayAnimationDirection)direction;

- (void)throwAwayContainerView:(RPLThrowAwayContainerView*)containerView
                        animatedView:(RPLThrowAwayAnimatedView*)animatedView
    didEndMovingAnimationToDirection:(RPLThrowAwayAnimationDirection)direction;

- (void)throwAwayContainerView:(RPLThrowAwayContainerView*)containerView
                  animatedView:(RPLThrowAwayAnimatedView*)animatedView
                didChangeAngle:(CGFloat)angle;

@end
