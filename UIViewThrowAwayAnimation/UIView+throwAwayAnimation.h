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


#import <UIKit/UIKit.h>

@interface UIView (throwAwayAnimation)

-(void)addThrowAwayAnimationWithCompletionHandler:(void(^)(void))actionBlock;
-(void)startThrowAwayAnimationWithDirection:(kThrowAwayAnimationDirection)animationDirection completionHandler:(void(^)(void))actionBlock;
-(void)removeThrowAwayAnimation;

@end
