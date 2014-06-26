//
//  RPLThrowAwayAnimationView_Private.h
//  ThrowAwayAnimationExample
//
//  Created by user on 27.04.14.
//  Copyright (c) 2014 RedPandazLabs. All rights reserved.
//

#import "RPLThrowAwayAnimationView.h"

static CGFloat const kRPLThrowAwayAnimationViewThresholdAngle = 5.f;

@interface RPLThrowAwayAnimationView()

- (void)delegateViewWillStartMovingAction;
- (void)delegateViewDidChangeAngle:(CGFloat)angle;
- (void)delegateViewDidReturnToInitialPoint;
- (void)delegateViewWillStartMovingAnimationToDirection:
    (RPLThrowAwayAnimationDirection)direction;
- (void)delegateViewDidEndMovingAnimationToDirection:
    (RPLThrowAwayAnimationDirection)direction;

@end
