//
//  UIView+throwAwayAnimation.m
//
//
//  Created by user on 27.05.13.
//  
//

#import "UIView+throwAwayAnimation.h"
#import <objc/runtime.h>

NSString * const kStartPointKey =       @"kStartPointKey";
NSString * const kEndPointKey =         @"kEndPointKey";
NSString * const kPanRecognizerKey =    @"kPanRecognizerKey";

static char UIViewThrowAwayCompletionBlockAction;
typedef void(^UIViewThrowAwayCompletionBlock)(void);


@interface UIView(Private)

@property (nonatomic)   CGPoint                             throwAwayStartPoint;
@property (nonatomic)   CGPoint                             throwAwayEndPoint;
@property (nonatomic)   UIViewThrowAwayCompletionBlock      throwAwayCompletionBlock;
@property (nonatomic)   UIPanGestureRecognizer              *throwAwayPanGestureRecognizer;

@end


@implementation UIView (throwAwayAnimation)


#pragma mark - Internal Properties -


- (void)setThrowAwayStartPoint:(CGPoint)throwAwayStartPoint
{
    NSValue *startPointValue=[NSValue valueWithCGPoint:throwAwayStartPoint];
	objc_setAssociatedObject(self, (__bridge const void *)(kStartPointKey), startPointValue, OBJC_ASSOCIATION_COPY);
}

-(CGPoint)throwAwayStartPoint
{
    NSValue *startPointValue=objc_getAssociatedObject(self, (__bridge const void *)(kStartPointKey));
	return  [startPointValue CGPointValue];
}




- (void)setThrowAwayEndPoint:(CGPoint)throwAwayEndPoint
{
    NSValue *endPointValue=[NSValue valueWithCGPoint:throwAwayEndPoint];
	objc_setAssociatedObject(self, (__bridge const void *)(kEndPointKey), endPointValue, OBJC_ASSOCIATION_COPY);
}

-(CGPoint)throwAwayEndPoint
{
    NSValue *endPointValue=objc_getAssociatedObject(self, (__bridge const void *)(kEndPointKey));
	return  [endPointValue CGPointValue];
}




-(void)setThrowAwayCompletionBlock:(UIViewThrowAwayCompletionBlock)throwAwayCompletionBlock
{
    objc_setAssociatedObject(self,
                             &UIViewThrowAwayCompletionBlockAction,
                             [throwAwayCompletionBlock copy],
                             OBJC_ASSOCIATION_COPY);
}

-(UIViewThrowAwayCompletionBlock)throwAwayCompletionBlock
{
    return objc_getAssociatedObject(self,
                                    &UIViewThrowAwayCompletionBlockAction);
}



- (void)setThrowAwayPanGestureRecognizer:(UIPanGestureRecognizer *)throwAwayPanGestureRecognizer
{
	objc_setAssociatedObject(self, (__bridge const void *)(kPanRecognizerKey), throwAwayPanGestureRecognizer, OBJC_ASSOCIATION_COPY);
}

-(UIPanGestureRecognizer*)throwAwayPanGestureRecognizer
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kPanRecognizerKey));
}






#pragma mark - Main Routines -







-(void)addThrowAwayAnimationWithCompletionHandler:(UIViewThrowAwayCompletionBlock)actionBlock
{
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handleThrowAwayPanRecognizer:)];
    [panGestureRecognizer setMaximumNumberOfTouches:2];
    [self addGestureRecognizer:panGestureRecognizer];
    
    self.throwAwayCompletionBlock=actionBlock ? actionBlock : nil;
}




-(void)startThrowAwayAnimationWithDirection:(kThrowAwayAnimationDirection)animationDirection completionHandler:(void(^)(void))actionBlock
{
    self.throwAwayStartPoint=self.center;
    self.throwAwayCompletionBlock=actionBlock ? actionBlock : nil;
    
#warning !!!IMPLEMENT IN FUTURE TO REAL VIEW BOUNDS SIZEs
    CGPoint destPoint=animationDirection == kThrowAwayAnimationDirectionRight ? CGPointMake(640.f, 400.f) : CGPointMake(-320.f, 400.f);
    [self _makeAnimationToPoint:destPoint velocity:CGPointMake(500.f, 500.f)];
}






-(void)removeThrowAwayAnimation
{
    self.throwAwayCompletionBlock=nil;
    [self.throwAwayPanGestureRecognizer removeTarget:self action:@selector(_handleThrowAwayPanRecognizer:)];
}




#pragma mark - UIGestureRecognizerDelegate





-(void)_handleThrowAwayPanRecognizer:(UIPanGestureRecognizer*)gesture
{
    CGFloat offset=self.superview.center.x-(  gesture.view.center.x+[gesture translationInView:self.superview].x);
    CGFloat angle=(  offset/(CGRectGetWidth(self.superview.bounds)/2)) * M_PI/20;
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        self.throwAwayStartPoint=gesture.view.center;
    };
    
    
    
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged)
    {
        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(-angle);
        gesture.view.transform=rotationTransform;
        
        CGPoint translation = [gesture translationInView:gesture.view.superview];
        gesture.view.center =CGPointMake(gesture.view.center.x + translation.x,
                                         gesture.view.center.y + translation.y);
        
        [gesture setTranslation:CGPointZero inView:gesture.view.superview];
    } else
        if (gesture.state == UIGestureRecognizerStateEnded)
        {
            self.throwAwayEndPoint=gesture.view.center;
            CGPoint resultPoint=linePointWithDistance(self.throwAwayStartPoint,self.throwAwayEndPoint,1000);

            /*
            UIView *view=[UIView viewWithFrame:self.superview.bounds drawRectBlock:^(CGRect rect)
                              {
                                  CGContextRef context = UIGraphicsGetCurrentContext();
                                  CGContextSetStrokeColorWithColor(context, UIColor.redColor.CGColor);
                                  CGContextSetLineWidth(context, 2.f);
                                  
                                  CGContextMoveToPoint(context, self.startP.x,self.startP.y);
                                  CGContextAddLineToPoint(context, resultPoint.x, resultPoint.y);
                                  CGContextStrokePath(context);
                              }];
                
            view.backgroundColor=[UIColor clearColor];
            view.userInteractionEnabled=NO;
            [self.superview addSubview:view];
            
            
            [view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:5.f];
            */
            
            if (fabsf(RADIANS_TO_DEGREES(angle))<2)
                  [self _centerAnimationWithVelocity:[gesture velocityInView:self.superview]];
            else
                [self _makeAnimationToPoint:resultPoint velocity:[gesture velocityInView:self.superview]];
        }
}








-(void)_makeAnimationToPoint:(CGPoint)destPoint velocity:(CGPoint)velocity
{
    NSTimeInterval duration=[self _durationFromVelocity:velocity];
    
    CGFloat angle=(  destPoint.x/(CGRectGetWidth(self.superview.bounds)/2)) * M_PI/20;
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    
    __weak typeof (self) weakSelf=self;
    [UIView animateWithDuration:duration delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.center=destPoint;
        weakSelf.transform=transform;
        
    } completion:^(BOOL finished)
     {
         if (weakSelf.throwAwayCompletionBlock)
             weakSelf.throwAwayCompletionBlock();
     }];
}





-(void)_centerAnimationWithVelocity:(CGPoint)velocity
{
    NSTimeInterval duration=[self _durationFromVelocity:velocity]/5;
    [UIView animateWithDuration:duration delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform=CGAffineTransformIdentity;
        self.center=self.throwAwayStartPoint;
    } completion:^(BOOL finished)
     {
     }];
}


-(NSTimeInterval)_durationFromVelocity:(CGPoint)velocity
{
    //
    // calc animation duration with velocity
    //
    CGFloat xPoints = CGRectGetWidth(self.superview.bounds);//320.0;
    CGFloat yPoints = CGRectGetHeight(self.superview.bounds);//320.0;
    CGFloat velocityX = velocity.x;
    CGFloat velocityY = velocity.y;
    NSTimeInterval duration = MIN( fabs((xPoints / velocityX)), fabs((yPoints / velocityY)) );
    
    duration=duration<0.5 ? 0.5f : duration;
    duration=duration>2.f ? 2.f : duration;
    
    return duration;
}






#pragma mark - some math -






CGPoint linePointWithDistance(CGPoint startPoint, CGPoint endPoint, CGFloat distance)
{
    float offX = startPoint.x - endPoint.x;
    float offY = startPoint.y - endPoint.y;
    float direction = atan2f(offY, offX);
    CGPoint resultPoint = CGPointMake(startPoint.x + cos(direction) * distance * -1, startPoint.y + sin(direction) * distance * -1);
    
    return resultPoint;
}


CGPoint LineIntersection(CGPoint v1, CGPoint v2, CGPoint v3, CGPoint v4)
{
    float tolerance = 0.000001f;
    float epsilon =   0.000000119f;
    
    float a = Det2(v1.x - v2.x, v1.y - v2.y, v3.x - v4.x, v3.y - v4.y);
    if (fabsf(a) < epsilon) return CGPointZero; // Lines are parallel
    
    float d1 = Det2(v1.x, v1.y, v2.x, v2.y);
    float d2 = Det2(v3.x, v3.y, v4.x, v4.y);
    float x = Det2(d1, v1.x - v2.x, d2, v3.x - v4.x) / a;
    float y = Det2(d1, v1.y - v2.y, d2, v3.y - v4.y) / a;
    
    if (x < MIN(v1.x, v2.x) - tolerance || x > MAX(v1.x, v2.x) + tolerance) return CGPointZero;
    if (y < MIN(v1.y, v2.y) - tolerance || y > MAX(v1.y, v2.y) + tolerance) return CGPointZero;
    if (x < MIN(v3.x, v4.x) - tolerance || x > MAX(v3.x, v4.x) + tolerance) return CGPointZero;
    if (y < MIN(v3.y, v4.y) - tolerance || y > MAX(v3.y, v4.y) + tolerance) return CGPointZero;
    
    return CGPointMake(x, y);
}



float Det2(float x1, float x2, float y1, float y2)
{
    return (x1 * y2 - y1 * x2);
}


@end