//
//  RPLThrowAwayAnimatedViewTests.m
//  ThrowAwayAnimationExample
//
//  Created by user on 27.04.14.
//  Copyright (c) 2014 RedPandazLabs. All rights reserved.
//

#import "RPLThrowAwayAnimatedView.h"
#import "RPLThrowAwayAnimatedView_Private.h"

#import "Kiwi.h"

SPEC_BEGIN(RPLThrowAwayAnimatedViewSpec)

describe(@"RPLThrowAwayAnimatedView", ^{
  __block RPLThrowAwayAnimatedView* view = nil;
  beforeEach(^{
    view = [[RPLThrowAwayAnimatedView alloc]
        initWithReuseIdentifier:@"identifier"];
    view.frame = CGRectMake(50, 50, 50, 50);
  });
  
  context(@"when created", ^{
    it(@"shoul set default threshold angle", ^{
      [[theValue(view.actionThresholdAngle) should] equal:
          theValue(kRPLThrowAwayAnimationViewThresholdAngle)];
    });
    
    specify(^{
      [[view.contentView should] beNonNil];
    });
    
    specify(^{
      [[view.contentView.superview should] beIdenticalTo:view];
    });
    
//    specify(^{
//      [[theValue(CGRectEqualToRect(view.contentView.frame, view.bounds))
//          should] beYes];
//    });
  });
  
  context(@"and responding to delegate", ^{
    __block NSObject<RPLThrowAwayAnimationViewDelegate>* delegate = nil;
    beforeEach(^{
      delegate =
          [KWMock mockForProtocol:@protocol(RPLThrowAwayAnimationViewDelegate)];
      view.delegate = delegate;
    });
    
    specify(^{
      [[delegate should] receive:@selector(viewDidReturnToInitialPoint:)];
      [view delegateViewDidReturnToInitialPoint];
    });

    specify(^{
      [[delegate should] receive:@selector(viewWillStartMovingAction:)];
      [view delegateViewWillStartMovingAction];
    });
    
    specify(^{
      [[delegate should]
          receive:@selector(view:willStartMovingAnimationToDirection:)];
      [view delegateViewWillStartMovingAnimationToDirection:
          RPLThrowAwayAnimationDirectionLeft];
    });
    
    specify(^{
      [[delegate should]
       receive:@selector(view:didEndMovingAnimationToDirection:)];
      [view delegateViewDidEndMovingAnimationToDirection:
          RPLThrowAwayAnimationDirectionLeft];
    });
    
    specify(^{
      [[delegate should] receive:@selector(view:didChangeAngle:)];
      [view delegateViewDidChangeAngle:0.f];
    });
  });
});

SPEC_END
