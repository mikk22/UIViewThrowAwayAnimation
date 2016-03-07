//
//  RPLViewController.m
//  ThrowAwayAnimationExample
//
//  Created by user on 28.05.13.
//  Copyright (c) 2013 RedPandazLabs. All rights reserved.
//

#import "RPLViewController.h"

#import "RPLThrowAwayAnimatedView.h"
#import "RPLThrowAwayContainerView.h"

@interface RPLViewController ()<
    RPLThrowAwayContainerViewDatasource,
    RPLThrowAwayContainerViewDelegate>

@property(nonatomic, strong) RPLThrowAwayContainerView* throwAwayView;
@property(nonatomic, strong) UIButton* yesButton;
@property(nonatomic, strong) UIButton* noButton;

//dataSource counter
@property(nonatomic, assign) NSUInteger viewsCounter;

@end

@implementation RPLViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor greenColor];
  [self setupView];
  [self setupButtons];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  self.throwAwayView.frame = CGRectInset(self.view.bounds, 20, 20);
  self.yesButton.frame = CGRectMake(20.f, CGRectGetHeight(self.throwAwayView.backgroundView.bounds)-60.f, 100.f, 40.f);
  self.noButton.frame = CGRectMake(CGRectGetWidth(self.throwAwayView.backgroundView.bounds)-120.f, CGRectGetHeight(self.throwAwayView.backgroundView.bounds)-60.f, 100.f, 40.f);
}

- (void)setupView {
  self.viewsCounter = 0;
  self.throwAwayView = [[RPLThrowAwayContainerView alloc] init];
  self.throwAwayView.backgroundColor = [UIColor orangeColor];
  self.throwAwayView.dataSource = self;
  self.throwAwayView.delegate = self;
  [self.view addSubview:self.throwAwayView];
}

- (void)setupButtons {
  self.yesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.yesButton setTitle:@"YES" forState:UIControlStateNormal];
  [self.yesButton addTarget:self action:@selector(yesButtonTouch:)
           forControlEvents:UIControlEventTouchUpInside];
  self.yesButton.layer.borderWidth = 1.f;
  [self.throwAwayView.backgroundView addSubview:self.yesButton];

  self.noButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.noButton setTitle:@"NO" forState:UIControlStateNormal];
  [self.noButton addTarget:self action:@selector(noButtonTouch:)
           forControlEvents:UIControlEventTouchUpInside];
  self.noButton.layer.borderWidth = 1.f;
  [self.throwAwayView.backgroundView addSubview:self.noButton];
}

- (void)yesButtonTouch:(id)sender {
  [self.throwAwayView performThrowAwayAnimationWithDirection:
      RPLThrowAwayAnimationDirectionLeft];
}

- (void)noButtonTouch:(id)sender {
  [self.throwAwayView performThrowAwayAnimationWithDirection:
      RPLThrowAwayAnimationDirectionRight];
}

#pragma mark - RPLThrowAwayViewDatasource 

- (RPLThrowAwayAnimatedView*)viewForIndex:(NSUInteger)index {
  static NSString* const reuseIdentifier = @"reuseIdentifier";

  RPLThrowAwayAnimatedView* view =
      [self.throwAwayView dequeueReusableViewWithIdentifier:reuseIdentifier];
  if (!view) {
    view = [[RPLThrowAwayAnimatedView alloc]
        initWithReuseIdentifier:reuseIdentifier];
  }
  
  UIColor* color = nil;
  switch (self.viewsCounter) {
    case 0:
      color = [UIColor whiteColor];
      break;
    case 1:
      color = [UIColor redColor];
      break;
    case 2:
      color = [UIColor yellowColor];
      break;
    case 3:
      color = [UIColor orangeColor];
      break;
    case 4:
      color = [UIColor blueColor];
      break;
    case 5:
      color = [UIColor darkGrayColor];
      break;
    case 6:
      color = [UIColor lightGrayColor];
      break;
    case 7:
      color = [UIColor grayColor];
      break;
    case 8:
      color = [UIColor greenColor];
      break;
    case 9:
      color = [UIColor cyanColor];
      break;
    case 10:
      color = [UIColor magentaColor];
      break;
    case 11:
      color = [UIColor orangeColor];
      break;
    case 12:
      color = [UIColor purpleColor];
      break;
    default:
      color = [UIColor blackColor];
      break;
  }
  
  view.backgroundColor = color;
  return view;
}

- (RPLThrowAwayAnimatedView*)viewForThrowAwayView:
    (RPLThrowAwayContainerView*)throwAwayView {
  RPLThrowAwayAnimatedView* view = [self viewForIndex:self.viewsCounter];
  ++self.viewsCounter;
  if (self.viewsCounter > 12) {
    self.viewsCounter = 0;
  }
  return view;
}

- (CGRect)throwAwayView:(RPLThrowAwayContainerView*)throwAwayView
           frameForView:(RPLThrowAwayAnimatedView*)view {
  CGRect rect = CGRectMake(0.f, 0.f, 100.f, 100.f);
  rect.origin.x = CGRectGetMidX(throwAwayView.bounds) - CGRectGetMidX(rect);
  rect.origin.y = CGRectGetMidY(throwAwayView.bounds) - CGRectGetMidY(rect);
  return rect;
}


@end
