//
//  UIView+throwAwayAnimation.h
//  
//
//  Created by user on 27.05.13.
//
//
#import <UIKit/UIKit.h>

#define RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f) // PI * 180

typedef enum {
    kThrowAwayAnimationDirectionRight=0,
    kThrowAwayAnimationDirectionLeft
} kThrowAwayAnimationDirection;

typedef void(^UIViewThrowAwayViewAngleDidChangeBlock)(CGFloat angle);
typedef void(^UIViewThrowAwayActionBlock)(kThrowAwayAnimationDirection direction);
typedef void(^UIViewThrowAwayBlock)(void);

@interface UIView (throwAwayAnimation)

//
// actionBlock is performed before animation starts
// it starts after user moves view or starts on StartThrowAwayAnimation action performed
//
@property (nonatomic, copy)   UIViewThrowAwayActionBlock                    throwAwayActionBlock;
//
// returnedToPlaceBlock is performed if animated view returns
// to its original place
//
@property (nonatomic, copy)   UIViewThrowAwayBlock                          throwAwayReturnedToPlaceBlock;
//
// startActionBlock is performed before animation starts
// sometimes you need to perform some action to prepare animation and superview of animated view
//
@property (nonatomic, copy)   UIViewThrowAwayBlock                          throwAwayStartActionBlock;
//
// throwAwayAngleDidChangeBlock is a block to perform some actions on changed angle of moved view
//
@property (nonatomic, copy)   UIViewThrowAwayViewAngleDidChangeBlock        throwAwayAngleDidChangeBlock;

-(void)addThrowAwayAnimation;
-(void)addThrowAwayAnimationWithCompletionHandler:(UIViewThrowAwayActionBlock)actionBlock;
-(void)startThrowAwayAnimationWithDirection:(kThrowAwayAnimationDirection)animationDirection;
-(void)startThrowAwayAnimationWithDirection:(kThrowAwayAnimationDirection)animationDirection completionHandler:(UIViewThrowAwayActionBlock)actionBlock;
-(void)removeThrowAwayAnimation;

@end
