//
//  RPLThrowAwayAnimatedView.h
//  ThrowAwayAnimationExample
//
//  Created by user on 26.04.14.
//  Copyright (c) 2014 RedPandazLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f) // PI * 180

typedef NS_ENUM(NSUInteger, RPLThrowAwayAnimationDirection) {
  RPLThrowAwayAnimationDirectionRight = 0,
  RPLThrowAwayAnimationDirectionLeft
};

@protocol RPLThrowAwayAnimationViewDelegate;

@interface RPLThrowAwayAnimatedView : UIView

@property(nonatomic, weak) id<RPLThrowAwayAnimationViewDelegate> delegate;
@property(nonatomic, assign) CGFloat actionThresholdAngle;
@property(nonatomic, strong, readonly) UIView* contentView;
@property(nonatomic, copy, readonly) NSString* reuseIdentifier;

- (instancetype)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)performThrowAwayAnimationWithDirection:
    (RPLThrowAwayAnimationDirection)animationDirection;

- (void)prepareForReuse;

@end

@protocol RPLThrowAwayAnimationViewDelegate <NSObject>

@optional
- (void)viewWillReturnToInitialPoint:(RPLThrowAwayAnimatedView*)view;
- (void)viewDidReturnToInitialPoint:(RPLThrowAwayAnimatedView*)view;
- (void)viewWillStartMovingAction:(RPLThrowAwayAnimatedView*)view;
- (void)view:(RPLThrowAwayAnimatedView*)view
    willStartMovingAnimationToDirection:
        (RPLThrowAwayAnimationDirection)direction;
- (void)view:(RPLThrowAwayAnimatedView*)view didEndMovingAnimationToDirection:
    (RPLThrowAwayAnimationDirection)direction;
- (void)view:(RPLThrowAwayAnimatedView*)view didChangeAngle:(CGFloat)angle;

@end
