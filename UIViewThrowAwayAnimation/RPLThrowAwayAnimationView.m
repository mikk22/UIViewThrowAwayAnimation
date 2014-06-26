//
//  RPLThrowAwayAnimationView.m
//  ThrowAwayAnimationExample
//
//  Created by user on 26.04.14.
//  Copyright (c) 2014 RedPandazLabs. All rights reserved.
//

#import "RPLThrowAwayAnimationView.h"
#import "RPLThrowAwayAnimationView_Private.h"

@interface RPLThrowAwayAnimationView()

@property(nonatomic, assign) CGPoint actionInitialPoint;
@property(nonatomic, strong, readwrite) UIView* contentView;

@end

@implementation RPLThrowAwayAnimationView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      _actionThresholdAngle = kRPLThrowAwayAnimationViewThresholdAngle;
      UIPanGestureRecognizer* panGestureRecognizer =
          [[UIPanGestureRecognizer alloc] initWithTarget:self
              action:@selector(handleThrowAwayPanRecognizer:)];
      [panGestureRecognizer setMaximumNumberOfTouches:2];
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

- (void)performThrowAwayAnimationWithDirection:
    (RPLThrowAwayAnimationDirection)animationDirection {
  [self delegateViewWillStartMovingAction];
//  [self delegateViewWillStartMovingAnimationToDirection:animationDirection];
  self.actionInitialPoint = self.center;
  
#warning !!!IMPLEMENT IN FUTURE TO REAL VIEW BOUNDS SIZEs
  CGPoint destPoint =
      (animationDirection == RPLThrowAwayAnimationDirectionRight)
          ? CGPointMake(640.f, CGRectGetWidth(self.superview.bounds)/2)
          : CGPointMake(-320.f, CGRectGetWidth(self.superview.bounds)/2);
  [self performAnimationToPoint:destPoint velocity:CGPointMake(500.f, 500.f)];
}

#pragma mark - UIGestureRecognizer

- (void)handleThrowAwayPanRecognizer:
    (UIPanGestureRecognizer*)gestureRecognizer {
  CGFloat offset =
      self.superview.center.x-(  gestureRecognizer.view.center.x +
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
      if (fabsf(RADIANS_TO_DEGREES(angle))<self.actionThresholdAngle) {
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
  
  duration=duration<0.5 ? 0.5f : duration;
  duration=duration>2.f ? 2.f : duration;
  
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
