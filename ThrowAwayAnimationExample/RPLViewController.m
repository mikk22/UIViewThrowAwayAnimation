//
//  RPLViewController.m
//  ThrowAwayAnimationExample
//
//  Created by user on 28.05.13.
//  Copyright (c) 2013 RedPandazLabs. All rights reserved.
//

#import "RPLViewController.h"
#import "UIView+throwAwayAnimation.h"

@interface RPLViewController ()

@property (nonatomic, strong)   UIView      *animatedView;

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
    self.animatedView.frame=CGRectMake(50.f, 50.f, CGRectGetWidth(self.view.bounds)-100.f, CGRectGetWidth(self.view.bounds)-100.f);
    self.animatedView.center=self.view.center;
}


-(void)_setupAnimatedView
{
    self.animatedView=[[UIView alloc] initWithFrame:CGRectZero];
    self.animatedView.backgroundColor=[UIColor lightGrayColor];
    __weak typeof (self) weakSelf=self;
    [self.animatedView addThrowAwayAnimationWithCompletionHandler:^
    {
        weakSelf.animatedView.transform=CGAffineTransformIdentity;
        weakSelf.animatedView.center=weakSelf.view.center;
    }];
    
    [self.view addSubview:self.animatedView];
}


@end
