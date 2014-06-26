//
//  RPLViewController.m
//  ThrowAwayAnimationExample
//
//  Created by user on 28.05.13.
//  Copyright (c) 2013 RedPandazLabs. All rights reserved.
//

#import "RPLViewController.h"

#import "RPLThrowAwayAnimationView.h"

@interface RPLViewController()<RPLThrowAwayAnimationViewDelegate>

@property (nonatomic, strong) RPLThrowAwayAnimationView* animatedView;

-(void)_setupAnimatedView;

@end

@implementation RPLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self _setupAnimatedView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.animatedView.frame = CGRectMake(50.f, 50.f, CGRectGetWidth(self.view.bounds)-100.f, CGRectGetWidth(self.view.bounds)-100.f);
    self.animatedView.center=self.view.center;
}


-(void)_setupAnimatedView {
  self.animatedView = [[RPLThrowAwayAnimationView alloc] init];
  self.animatedView.delegate = self;
    self.animatedView.backgroundColor=[UIColor lightGrayColor];
//    [self.animatedView addThrowAwayAnimationWithCompletionHandler:^
//    {
//    }];
  
    [self.view addSubview:self.animatedView];
}

#pragma mark - delegate

- (void)viewDidEndMovingAnimationToDirection:
(RPLThrowAwayAnimationDirection)direction {
  self.animatedView.transform=CGAffineTransformIdentity;
  self.animatedView.center=self.view.center;
}




@end
