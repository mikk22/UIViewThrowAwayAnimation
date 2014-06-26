//
//  RPLThrowAwayAnimationView.h
//  ThrowAwayAnimationExample
//
//  Created by user on 26.04.14.
//  Copyright (c) 2014 RedPandazLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f) // PI * 180

typedef NS_ENUM(NSUInteger, RPLThrowAwayAnimationDirection) {
  RPLThrowAwayAnimationDirectionRight=0,
  RPLThrowAwayAnimationDirectionLeft
};

@protocol RPLThrowAwayAnimationViewDelegate;

@interface RPLThrowAwayAnimationView : UIView

@property(nonatomic, weak) id<RPLThrowAwayAnimationViewDelegate> delegate;
@property(nonatomic, assign) CGFloat actionThresholdAngle;
@property(nonatomic, strong, readonly) UIView* contentView;

- (void)performThrowAwayAnimationWithDirection:
    (RPLThrowAwayAnimationDirection)animationDirection;

@end

@protocol RPLThrowAwayAnimationViewDelegate <NSObject>

@optional
- (void)viewWillReturnToInitialPoint:(RPLThrowAwayAnimationView*)view;
- (void)viewDidReturnToInitialPoint:(RPLThrowAwayAnimationView*)view;
- (void)viewWillStartMovingAction:(RPLThrowAwayAnimationView*)view;
- (void)view:(RPLThrowAwayAnimationView*)view
    willStartMovingAnimationToDirection:
        (RPLThrowAwayAnimationDirection)direction;
- (void)view:(RPLThrowAwayAnimationView*)view didEndMovingAnimationToDirection:
    (RPLThrowAwayAnimationDirection)direction;
- (void)view:(RPLThrowAwayAnimationView*)view didChangeAngle:(CGFloat)angle;

@end
