//
//  RPLThrowAwayView_Private.h
//  ThrowAwayAnimationExample
//
//  Created by user on 22.08.14.
//  Copyright (c) 2014 RedPandazLabs. All rights reserved.
//

#import "RPLThrowAwayContainerView.h"

#import "RPLThrowAwayAnimatedView.h"

@interface RPLThrowAwayContainerView ()<RPLThrowAwayAnimationViewDelegate>

@property(nonatomic, assign) BOOL firstInitialized;
@property(nonatomic, strong) NSMutableArray* views;
@property(nonatomic, strong) NSMutableDictionary* queueViews;

@property(nonatomic, strong, readwrite) UIView* backgroundView;

- (void)queueView:(RPLThrowAwayAnimatedView*)view;
- (void)loadViews;
- (void)addNextView;

@end
