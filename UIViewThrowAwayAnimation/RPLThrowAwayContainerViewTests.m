//
//  RPLThrowAwayContainerViewTests.m
//  ThrowAwayAnimationExample
//
//  Created by user on 22.08.14.
//  Copyright (c) 2014 RedPandazLabs. All rights reserved.
//

#import "RPLThrowAwayContainerView.h"
#import "RPLThrowAwayContainerView_Private.h"

#import "Kiwi.h"

SPEC_BEGIN(RPLThrowAwayContainerViewSpec)
describe(@"RPLThrowAwayContainerView", ^{
  __block RPLThrowAwayContainerView* containerView = nil;
  __block id<RPLThrowAwayViewDatasource> dataSource = nil;
  
  beforeEach(^{
    dataSource =
        [KWMock nullMockForProtocol:@protocol(RPLThrowAwayViewDatasource)];
    containerView = [[RPLThrowAwayContainerView alloc] initWithFrame:
        CGRectMake(0.f, 0.f, 100.f, 100.f)];
    containerView.dataSource = dataSource;
  });
  
  afterEach(^{
    dataSource = nil;
    containerView = nil;
  });
  
  context(@"when created", ^{
    specify(^{
      [[containerView should] beNonNil];
      [[containerView.views should] beNonNil];
      [[containerView.queueViews should] beNonNil];
      [[theValue(containerView.firstInitialized) should] beNo];
      [[containerView.backgroundView should] beNonNil];
      [[theValue([containerView.backgroundView
          isDescendantOfView:containerView]) should] beYes];
    });
    
    context(@"and layout subviews", ^{
      dispatch_block_t layoutSubviews = ^{
        [containerView setNeedsLayout];
        [containerView layoutIfNeeded];
      };
      
      context(@"when not initialized", ^{
        beforeEach(^{
          containerView.firstInitialized = NO;
        });
        
        specify(^{
          [[containerView should] receive:@selector(loadViews)];
          layoutSubviews();
        });
      });
      
      context(@"when already initialized", ^{
        beforeEach(^{
          containerView.firstInitialized = YES;
        });
      
        specify(^{
          [[containerView shouldNot] receive:@selector(loadViews)];
          layoutSubviews();
        });
        
        specify(^{
          layoutSubviews();
          [[@(CGRectEqualToRect(containerView.bounds,
              containerView.backgroundView.frame)) should] beYes];
        });
      });
    });
    
    context(@"and loads views", ^{
      specify(^{
        [[containerView should] receive:@selector(addNextView)
                              withCount:2];
        [containerView loadViews];
      });
    });
    
    context(@"and adds animated view", ^{
      __block RPLThrowAwayAnimatedView* animationView = nil;
      
      beforeEach(^{
        animationView = [[RPLThrowAwayAnimatedView alloc]
            initWithReuseIdentifier:@"identifier"];
        [(id)dataSource stub:@selector(viewForThrowAwayView:)
                   andReturn:animationView];
      });
      
      afterEach(^{
        animationView = nil;
      });
      
      it(@"should load view from dataSource", ^{
        [[(id)dataSource should] receive:@selector(viewForThrowAwayView:)
                               andReturn:animationView
                           withArguments:containerView, nil];
        [containerView addNextView];
      });

      it(@"should ask dataSource about view's frame", ^{
        [[(id)dataSource should] receive:@selector(throwAwayView:frameForView:)
                               andReturn:theValue(CGRectZero)
                           withArguments:containerView, animationView, nil];
        [containerView addNextView];
      });
      
      specify(^{
        [containerView addNextView];
        [[theValue([animationView isDescendantOfView:containerView])
            should] beYes];
      });
      
      specify(^{
        [containerView addNextView];
        [[containerView.views should] contain:animationView];
      });
      
      specify(^{
        [containerView addNextView];
        [[theValue(animationView.delegate == containerView) should] beYes];
      });
      
      context(@"when moving animation started", ^{
        beforeEach(^{
          [containerView addNextView];
        });
        
        it(@"should add next view", ^{
          [[containerView should] receive:@selector(addNextView)];
          [containerView view:animationView
              willStartMovingAnimationToDirection:
                  RPLThrowAwayAnimationDirectionRight];
        });
      });
      
      context(@"when moving animation ends", ^{
        beforeEach(^{
          [containerView addNextView];
        });
        
        it(@"should remove animated view from container view", ^{
          [[animationView should] receive:@selector(removeFromSuperview)];
          [containerView view:animationView
              didEndMovingAnimationToDirection:
                  RPLThrowAwayAnimationDirectionRight];
        });
        
        it(@"should queue animated view and prepare for reuse", ^{
          [[animationView should] receive:@selector(prepareForReuse)];
          [[containerView should] receive:@selector(queueView:)
                            withArguments:animationView, nil];
          [containerView view:animationView
              didEndMovingAnimationToDirection:
                  RPLThrowAwayAnimationDirectionRight];
        });
      });
      
      context(@"when queues view", ^{
        it(@"should add view to qeues", ^{
          [[containerView.queueViews should]
                    receive:@selector(setObject:forKey:)
              withArguments:animationView,
                            animationView.reuseIdentifier,
                            nil];
          [containerView queueView:animationView];
        });
      });
      
      context(@"when dequeue animated view", ^{
        //TO DO tests!!!
      });
    });
    
    context(@"and responds to delegate", ^{
      __block id<RPLThrowAwayViewDelegate> delegate = nil;

      beforeEach(^{
        delegate = [KWMock nullMockForProtocol:@protocol(RPLThrowAwayViewDelegate)];
        containerView.delegate = delegate;
      });
      
      afterEach(^{
        delegate = nil;
      });
    
      specify(^{
        [[(id)delegate should] receive:
            @selector(throwAwayContainerView:animatedViewWillReturnToInitialPoint:)];
        [containerView viewWillReturnToInitialPoint:nil];
      });
      
      specify(^{
        [[(id)delegate should] receive:
         @selector(throwAwayContainerView:animatedViewDidReturnToInitialPoint:)];
        [containerView viewDidReturnToInitialPoint:nil];
      });
      
      specify(^{
        [[(id)delegate should] receive:
            @selector(throwAwayContainerView:animatedViewWillStartMovingAction:)];
        [containerView viewWillStartMovingAction:nil];
      });
      
      specify(^{
        [[containerView should] receive:@selector(addNextView)];
        [[(id)delegate should] receive:
            @selector(throwAwayContainerView:animatedView:willStartMovingAnimationToDirection:)];
        [containerView view:nil
            willStartMovingAnimationToDirection:
                RPLThrowAwayAnimationDirectionLeft];
      });
      
      specify(^{
        [[(id)delegate should] receive:
            @selector(throwAwayContainerView:animatedView:didChangeAngle:)];
        [containerView view:nil didChangeAngle:0.f];
      });

      specify(^{
        RPLThrowAwayAnimatedView* animatedView =
            [[RPLThrowAwayAnimatedView alloc]
                initWithReuseIdentifier:@"identifier"];
        [[(id)delegate should] receive:
            @selector(throwAwayContainerView:animatedView:didEndMovingAnimationToDirection:)];
        
        [containerView view:animatedView
            didEndMovingAnimationToDirection:
                RPLThrowAwayAnimationDirectionLeft];
      });

      it(@"should invoke prepared action for animated view "
          "when animation ends", ^{
        RPLThrowAwayAnimatedView* animatedView =
            [[RPLThrowAwayAnimatedView alloc]
                initWithReuseIdentifier:@"identifier"];
        [[animatedView should] receive:@selector(removeFromSuperview)];
        [[animatedView should] receive:@selector(prepareForReuse)];
        [[containerView should] receive:@selector(queueView:)
                          withArguments:animatedView, nil];
            
        [containerView view:animatedView
            didEndMovingAnimationToDirection:
                RPLThrowAwayAnimationDirectionLeft];
      });
    });
  });
});

SPEC_END