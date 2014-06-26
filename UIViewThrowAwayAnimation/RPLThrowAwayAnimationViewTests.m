//
//  RPLThrowAwayAnimationViewTests.m
//  ThrowAwayAnimationExample
//
//  Created by user on 27.04.14.
//  Copyright (c) 2014 RedPandazLabs. All rights reserved.
//

#import "Kiwi.h"

#import "RPLThrowAwayAnimationView.h"
#import "RPLThrowAwayAnimationView_Private.h"

SPEC_BEGIN(RPLThrowAwayAnimationViewSpec)

describe(@"RPLThrowAwayAnimationView", ^{
  __block RPLThrowAwayAnimationView* view = nil;
  beforeEach(^{
    view = [[RPLThrowAwayAnimationView alloc] initWithFrame:
        CGRectMake(50, 50, 50, 50)];
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
  
  context(@"when responding to delegate", ^{
    __block NSObject<RPLThrowAwayAnimationViewDelegate>* delegate = nil;
    beforeEach(^{
      delegate =
          [KWMock mockForProtocol:@protocol(RPLThrowAwayAnimationViewDelegate)];
      view.delegate = delegate;
    });
    
    specify(^{
      [[delegate should] receive:@selector(viewDidReturnToInitialPoint)];
      [view delegateViewDidReturnToInitialPoint];
    });

    specify(^{
      [[delegate should] receive:@selector(viewWillStartMovingAction)];
      [view delegateViewWillStartMovingAction];
    });
    
    specify(^{
      [[delegate should]
          receive:@selector(viewWillStartMovingAnimationToDirection:)];
      [view delegateViewWillStartMovingAnimationToDirectionn:
          RPLThrowAwayAnimationDirectionLeft];
    });
    
    specify(^{
      [[delegate should]
          receive:@selector(viewDidEndMovingAnimationToDirection:)];
      [view delegateViewDidEndMovingAnimationToDirection:
          RPLThrowAwayAnimationDirectionLeft];
    });
    
    specify(^{
      [[delegate should] receive:@selector(viewDidChangeAngle:)];
      [view delegateViewDidChangeAngle:0.f];
    });
  });
});

SPEC_END
