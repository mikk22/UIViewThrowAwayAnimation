//
//  UIView+throwAwayAnimation.h
//  
//
//  Created by user on 27.05.13.
//
//


typedef enum {
    kThrowAwayAnimationDirectionRight=0,
    kThrowAwayAnimationDirectionLeft
} kThrowAwayAnimationDirection;

typedef void(^UIViewThrowAwayActionBlock)(kThrowAwayAnimationDirection direction);

#import <UIKit/UIKit.h>

@interface UIView (throwAwayAnimation)

@property (nonatomic)   UIViewThrowAwayActionBlock          throwAwayActionBlock;

-(void)addThrowAwayAnimationWithCompletionHandler:(UIViewThrowAwayActionBlock)actionBlock;
-(void)startThrowAwayAnimationWithDirection:(kThrowAwayAnimationDirection)animationDirection;
-(void)startThrowAwayAnimationWithDirection:(kThrowAwayAnimationDirection)animationDirection completionHandler:(UIViewThrowAwayActionBlock)actionBlock;
-(void)removeThrowAwayAnimation;

@end
