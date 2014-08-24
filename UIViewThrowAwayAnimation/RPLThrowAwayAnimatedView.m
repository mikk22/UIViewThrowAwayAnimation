//
//  RPLThrowAwayAnimatedView.m
//  ThrowAwayAnimationExample
//
//  Created by user on 26.04.14.
//  Copyright (c) 2014 RedPandazLabs. All rights reserved.
//

#import "RPLThrowAwayAnimatedView.h"
#import "RPLThrowAwayAnimatedView_Private.h"

@interface RPLThrowAwayAnimatedView ()

@property(nonatomic, assign) CGPoint actionInitialPoint;
@property(nonatomic, strong, readwrite) UIView* contentView;

@end

@implementation RPLThrowAwayAnimatedView

- (id)initWithFrame:(CGRect)frame {
  NSAssert(NO, @"use initWithReuseIdentifier: instead");
  return nil;
}

- (instancetype)initWithReuseIdentifier:(NSString*)reuseIdentifier {
  NSParameterAssert(reuseIdentifier);
  self = [super initWithFrame:CGRectZero];
  if (self) {
    _reuseIdentifier = reuseIdentifier;
    _actionThresholdAngle = kRPLThrowAwayAnimationViewThresholdAngle;
    UIPanGestureRecognizer* panGestureRecognizer =
        [self createPanGestureRecognizer];
    [self addGestureRecognizer:panGestureRecognizer];
  }
  return self;
}

- (UIView*)contentView {
  if (!_contentView) {
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    _contentView.backgroundColor = [UIColor greenColor];
    _contentView.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_contentView];
  }
  return _contentView;
}

- (UIPanGestureRecognizer*)createPanGestureRecognizer {
  UIPanGestureRecognizer* panGestureRecognizer =
      [[UIPanGestureRecognizer alloc] initWithTarget:self
          action:@selector(handleThrowAwayPanRecognizer:)];
  [panGestureRecognizer setMaximumNumberOfTouches:2];
  return panGestureRecognizer;
}

- (void)prepareForReuse {
  self.transform = CGAffineTransformIdentity;
}

- (void)performThrowAwayAnimationWithDirection:
    (RPLThrowAwayAnimationDirection)animationDirection {
  [self delegateViewWillStartMovingAction];
  self.actionInitialPoint = self.center;
  
  CGFloat movingWidth = ceilf(CGRectGetWidth(self.bounds) * 1.5/2);
  CGPoint leftDestPoint =
      CGPointMake(-movingWidth,
                  ceilf(CGRectGetMidY(self.superview.bounds)*1.2f));
  CGPoint rightDestPoint =
      CGPointMake(CGRectGetWidth(self.superview.bounds) + movingWidth,
                  ceilf(CGRectGetMidY(self.superview.bounds)*1.2f));
  CGPoint destPoint =
      (animationDirection == RPLThrowAwayAnimationDirectionRight)
          ? rightDestPoint
          : leftDestPoint;
  [self performAnimationToPoint:destPoint velocity:CGPointMake(500.f, 500.f)];
}

#pragma mark - UIGestureRecognizer

- (void)handleThrowAwayPanRecognizer:
    (UIPanGestureRecognizer*)gestureRecognizer {
  CGFloat offset =
      CGRectGetMidX(self.superview.bounds) -
          (gestureRecognizer.view.center.x +
              [gestureRecognizer translationInView:self.superview].x);
  CGFloat angle = (offset/(CGRectGetWidth(self.superview.bounds)/2)) * M_PI/20;
  
  if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    self.actionInitialPoint = gestureRecognizer.view.center;

    [self delegateViewWillStartMovingAction];
  };
  
  if (gestureRecognizer.state == UIGestureRecognizerStateBegan ||
      gestureRecognizer.state == UIGestureRecognizerStateChanged) {
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(-angle);
    gestureRecognizer.view.transform = rotationTransform;
    
    CGPoint translation =
        [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    gestureRecognizer.view.center =
        CGPointMake(gestureRecognizer.view.center.x + translation.x,
                    gestureRecognizer.view.center.y + translation.y);
    
    [gestureRecognizer setTranslation:CGPointZero
                               inView:gestureRecognizer.view.superview];
    
    [self delegateViewDidChangeAngle:angle];
  } else
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
      CGPoint endPoint = gestureRecognizer.view.center;
      CGPoint resultPoint = linePointWithDistance(self.actionInitialPoint,
                                                  endPoint,
                                                  1000);
      
      CGPoint velocity = [gestureRecognizer velocityInView:self.superview];
      if (fabsf(RADIANS_TO_DEGREES(angle)) < self.actionThresholdAngle) {
        [self performAnimationToInitialPointWithVelocity:velocity];
      } else {
        [self performAnimationToPoint:resultPoint velocity:velocity];
      }
    }
}

- (void)performAnimationToInitialPointWithVelocity:(CGPoint)velocity {
  [self delegateViewWillReturnToInitialPoint];
  NSTimeInterval duration = [self animationDurationFromVelocity:velocity]/5;
  [UIView animateWithDuration:duration
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
    self.transform = CGAffineTransformIdentity;
    self.center = self.actionInitialPoint;
    
    //[self delegateViewDidChangeAngle:angle];
//            if (self.throwAwayAngleDidChangeBlock)
//                self.throwAwayAngleDidChangeBlock(angle);
    
  } completion:^(BOOL finished) {
    if (finished) {
      [self delegateViewDidReturnToInitialPoint];
    }
   }];
}

- (void)performAnimationToPoint:(CGPoint)destPoint velocity:(CGPoint)velocity {
  NSTimeInterval duration = [self animationDurationFromVelocity:velocity];
  CGFloat angle =
      (  destPoint.x/(CGRectGetWidth(self.superview.bounds)/2)) * M_PI/20;
  CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
  
  RPLThrowAwayAnimationDirection direction =
      destPoint.x <= 0 ? RPLThrowAwayAnimationDirectionLeft
          : RPLThrowAwayAnimationDirectionRight;
  [self delegateViewWillStartMovingAnimationToDirection:direction];
  
  __weak typeof (self) weakSelf=self;
  [UIView animateWithDuration:duration
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
    weakSelf.center=destPoint;
    weakSelf.transform=transform;
    
#pragma mark !!! warning
    //        if (self.throwAwayAngleDidChangeBlock)
    //            self.throwAwayAngleDidChangeBlock(angle);
    
  } completion:^(BOOL finished) {
    [self delegateViewDidEndMovingAnimationToDirection:direction];
   }];
}

-(NSTimeInterval)animationDurationFromVelocity:(CGPoint)velocity {
  CGFloat xPoints = CGRectGetWidth(self.superview.bounds);
  CGFloat yPoints = CGRectGetHeight(self.superview.bounds);
  CGFloat velocityX = velocity.x;
  CGFloat velocityY = velocity.y;
  NSTimeInterval duration = MIN(fabs((xPoints / velocityX)),
                                fabs((yPoints / velocityY)));
  
  static CGFloat const kRPLThrowAwayAnimationViewMinDuration = .3f;
  duration = duration < kRPLThrowAwayAnimationViewMinDuration
      ? kRPLThrowAwayAnimationViewMinDuration
      : duration;
  static CGFloat const kRPLThrowAwayAnimationViewMaxDuration = 1.5f;
  duration = duration > kRPLThrowAwayAnimationViewMaxDuration
      ? kRPLThrowAwayAnimationViewMaxDuration
      : duration;
  
  return duration;
}

#pragma - delegate private methods

- (void)delegateViewWillStartMovingAction {
  if ([self.delegate respondsToSelector:
      @selector(viewWillStartMovingAction:)]) {
    [self.delegate viewWillStartMovingAction:self];
  }
}

- (void)delegateViewDidChangeAngle:(CGFloat)angle {
  if ([self.delegate respondsToSelector:@selector(view:didChangeAngle:)]) {
    [self.delegate view:self didChangeAngle:angle];
  }
}

- (void)delegateViewWillReturnToInitialPoint {
  if ([self.delegate respondsToSelector:
      @selector(viewWillReturnToInitialPoint:)]) {
    [self.delegate viewWillReturnToInitialPoint:self];
  }
}

- (void)delegateViewDidReturnToInitialPoint {
  if ([self.delegate respondsToSelector:
      @selector(viewDidReturnToInitialPoint:)]) {
    [self.delegate viewDidReturnToInitialPoint:self];
  }
}

- (void)delegateViewWillStartMovingAnimationToDirection:
    (RPLThrowAwayAnimationDirection)direction {
  if ([self.delegate respondsToSelector:
      @selector(view:willStartMovingAnimationToDirection:)]) {
    [self.delegate view:self willStartMovingAnimationToDirection:direction];
  }
}

- (void)delegateViewDidEndMovingAnimationToDirection:
    (RPLThrowAwayAnimationDirection)direction {
  if ([self.delegate respondsToSelector:
       @selector(view:didEndMovingAnimationToDirection:)]) {
    [self.delegate view:self didEndMovingAnimationToDirection:direction];
  }
}

#pragma - helper methods

CGPoint linePointWithDistance(CGPoint startPoint,
                              CGPoint endPoint,
                              CGFloat distance) {
  float offX = startPoint.x - endPoint.x;
  float offY = startPoint.y - endPoint.y;
  float direction = atan2f(offY, offX);
  CGPoint resultPoint =
      CGPointMake(startPoint.x + cos(direction) * distance * -1,
                  startPoint.y + sin(direction) * distance * -1);
  
  return resultPoint;
}

@end
