//
//  RPLThrowAwayContainerView.m
//  ThrowAwayAnimationExample
//
//  Created by user on 21.08.14.
//  Copyright (c) 2014 RedPandazLabs. All rights reserved.
//

// TODO: check that backgroundView at index = 0

#import "RPLThrowAwayContainerView.h"
#import "RPLThrowAwayContainerView_Private.h"

@implementation RPLThrowAwayContainerView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _firstInitialized = NO;
    _backgroundView = [self createBackgroundView];
    [self addSubview:_backgroundView];
    self.clipsToBounds = YES;
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.backgroundView.frame = self.bounds;
  if (!self.firstInitialized) {
    [self loadViews];
    self.firstInitialized = YES;
  }
}

#pragma mark - Public

- (RPLThrowAwayAnimatedView*)dequeueReusableViewWithIdentifier:
    (NSString*)reuseIdentifier {
  NSParameterAssert(reuseIdentifier);
	if (![self.queueViews count]) {
		return nil;
  }
	
	RPLThrowAwayAnimatedView *view =
      [self.queueViews objectForKey:reuseIdentifier];
	[self.queueViews removeObjectForKey:reuseIdentifier];
	
	return view;
}

- (void)reloadData {
  for (UIView* view in self.views) {
    NSParameterAssert([view isKindOfClass:[UIView class]]);
    [view removeFromSuperview];
  }
  
  self.queueViews = nil;
  self.views = nil;
  [self loadViews];
  [self setNeedsLayout];
}

- (void)performThrowAwayAnimationWithDirection:
    (RPLThrowAwayAnimationDirection)animationDirection {
  if ([self.views count]) {
    RPLThrowAwayAnimatedView* view = self.views[0];
    [self.views removeObject:view];
    [view performThrowAwayAnimationWithDirection:animationDirection];
  }
}

#pragma mark - Properties

- (NSMutableDictionary*)queueViews {
  if (!_queueViews) {
    _queueViews = [[NSMutableDictionary alloc] init];
  }
  return _queueViews;
}

- (NSMutableArray*)views {
  if (!_views) {
    _views = [[NSMutableArray alloc] init];
  }
  return _views;
}

- (NSArray*)containedViews {
  return [self.views copy];
}

#pragma mark - Private

- (UIView*)createBackgroundView {
  UIView* backgroundView = [[UIView alloc] init];
  backgroundView.backgroundColor = [UIColor clearColor];
  backgroundView.autoresizesSubviews = YES;
  backgroundView.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  return backgroundView;
}

- (void)queueView:(RPLThrowAwayAnimatedView*)view {
  NSParameterAssert(view.reuseIdentifier);
  [self.queueViews setObject:view
                      forKey:view.reuseIdentifier];
}

- (void)loadViews {
  static NSUInteger const kRPLMinVisibleViewsCount = 2;
  for (NSUInteger visibleViewsCount = 0;
       visibleViewsCount < kRPLMinVisibleViewsCount;
       ++visibleViewsCount) {
    [self addNextView];
  }
}

- (void)addNextView {
  RPLThrowAwayAnimatedView* view = [self.dataSource viewForThrowAwayView:self];
  if (view) {
    NSParameterAssert([view isKindOfClass:[RPLThrowAwayAnimatedView class] ]);
    view.delegate = self;
    view.frame = [self.dataSource throwAwayView:self frameForView:view];
    [self insertSubview:view aboveSubview:self.backgroundView];
    [self.views addObject:view];
  }
}

#pragma mark - RPLThrowAwayAnimationViewDelegate

- (void)viewWillReturnToInitialPoint:(RPLThrowAwayAnimatedView*)view {
  [self delegateAnimatedViewWillReturnToInitialPoint:view];
}

- (void)viewDidReturnToInitialPoint:(RPLThrowAwayAnimatedView*)view {
  [self delegateAnimatedViewDidReturnToInitialPoint:view];
}

- (void)viewWillStartMovingAction:(RPLThrowAwayAnimatedView*)view {
  [self delegateAnimatedViewWillStartMovingAction:view];
}

- (void)view:(RPLThrowAwayAnimatedView*)view
    willStartMovingAnimationToDirection:
        (RPLThrowAwayAnimationDirection)direction {
  [self addNextView];
  
  [self delegateAnimatedView:view
      willStartMovingAnimationToDirection:direction];
}

- (void)view:(RPLThrowAwayAnimatedView*)view
    didEndMovingAnimationToDirection:
        (RPLThrowAwayAnimationDirection)direction {
  [self.views removeObject:view];
  [view removeFromSuperview];
  [view prepareForReuse];
  [self queueView:view];
  
  [self delegateAnimatedView:view
      didEndMovingAnimationToDirection:direction];
}

- (void)view:(RPLThrowAwayAnimatedView*)view didChangeAngle:(CGFloat)angle {
  [self delegateAnimatedView:view didChangeAngle:angle];
}

#pragma mark -

- (void)delegateAnimatedViewWillReturnToInitialPoint:
    (RPLThrowAwayAnimatedView*)animatedView {
  if ([self.delegate respondsToSelector:
          @selector(throwAwayContainerView:animatedViewWillReturnToInitialPoint:)]) {
    [self.delegate throwAwayContainerView:self
        animatedViewWillReturnToInitialPoint:animatedView];
  }
}

- (void)delegateAnimatedViewDidReturnToInitialPoint:
    (RPLThrowAwayAnimatedView*)animatedView {
  if ([self.delegate respondsToSelector:
          @selector(throwAwayContainerView:animatedViewDidReturnToInitialPoint:)]) {
    [self.delegate throwAwayContainerView:self
        animatedViewDidReturnToInitialPoint:animatedView];
  }
}

- (void)delegateAnimatedViewWillStartMovingAction:
    (RPLThrowAwayAnimatedView*)animatedView {
  if ([self.delegate respondsToSelector:
          @selector(throwAwayContainerView:animatedViewWillStartMovingAction:)]) {
    [self.delegate throwAwayContainerView:self
      animatedViewWillStartMovingAction:animatedView];
  }
}

- (void)delegateAnimatedView:(RPLThrowAwayAnimatedView*)animatedView
    willStartMovingAnimationToDirection:
        (RPLThrowAwayAnimationDirection)direction {
  if ([self.delegate respondsToSelector:
          @selector(throwAwayContainerView:animatedView:willStartMovingAnimationToDirection:)]) {
    [self.delegate throwAwayContainerView:self
                             animatedView:animatedView
      willStartMovingAnimationToDirection:direction];
  }
}

- (void)delegateAnimatedView:(RPLThrowAwayAnimatedView*)animatedView
    didEndMovingAnimationToDirection:(RPLThrowAwayAnimationDirection)direction {
  if ([self.delegate respondsToSelector:
          @selector(throwAwayContainerView:animatedView:didEndMovingAnimationToDirection:)]) {
    [self.delegate throwAwayContainerView:self
                             animatedView:animatedView
         didEndMovingAnimationToDirection:direction];
  }
}

- (void)delegateAnimatedView:(RPLThrowAwayAnimatedView*)animatedView
              didChangeAngle:(CGFloat)angle {
  if ([self.delegate respondsToSelector:
          @selector(throwAwayContainerView:animatedView:didChangeAngle:)]) {
    [self.delegate throwAwayContainerView:self
                             animatedView:animatedView
                           didChangeAngle:angle];
  }
}

@end
