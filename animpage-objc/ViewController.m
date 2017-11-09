//
//  ViewController.m
//  animpage-objc
//
//  Created by Ahmad Saifuddin on 11/6/17.
//  Copyright © 2017 Ahmad Saifuddin. All rights reserved.
//

#import "ViewController.h"

#define TOP 0
#define FRONT 1
#define MIDDLE 2
#define BACK 3
#define SCREENSHOT 4

#define SWIPE_UP_THRESHOLD -1000.0f
#define SWIPE_DOWN_THRESHOLD 1000.0f
#define SWIPE_LEFT_THRESHOLD -1000.0f
#define SWIPE_RIGHT_THRESHOLD 1000.0f

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (strong, nonatomic) NSMutableArray *stackedPages;
@property (strong, nonatomic) UIPanGestureRecognizer *panSwipeRecognizer;
@property (nonatomic) CGRect initialPositionForTopView;
@property (nonatomic) CGRect initialPositionForFrontView;
@property (nonatomic) CGRect initialPositionForMiddleView;
@property (nonatomic) CGRect initialPositionForBackView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _initialPositionForFrontView = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 100);
    _initialPositionForTopView = CGRectMake( _initialPositionForFrontView.origin.x, -_initialPositionForFrontView.size.height, _initialPositionForFrontView.size.width, _initialPositionForFrontView.size.height);
    _initialPositionForMiddleView = CGRectMake(0 + 20, 70, self.view.frame.size.width - 20 - 20, self.view.frame.size.height - 70 - 70);
    _initialPositionForBackView = CGRectMake(0 + 20 + 20, 50, self.view.frame.size.width - 20 - 20 - 20 - 20, self.view.frame.size.height - 70 - 70 - 70);
    
    _view1.frame = _initialPositionForTopView;
    _view2.frame = _initialPositionForFrontView;
    _view3.frame = _initialPositionForMiddleView;
    _view3.alpha = 0.4;
    _view4.frame = _initialPositionForBackView;
    _view4.alpha = 0.2;
    
    // Postions: Top, Front, Middle, Back
    _stackedPages = [NSMutableArray arrayWithObjects:_view1, _view2, _view3, _view4, nil];
    
    _panSwipeRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanSwipe:)];
    _panSwipeRecognizer.minimumNumberOfTouches = 1;
    
    [self resetRecognizer];
    NSLog(@"%@", _stackedPages);
}

- (void)shiftViewsInArrayRight
{
    [_stackedPages insertObject:_stackedPages.lastObject atIndex:0];
    [_stackedPages removeLastObject];
    NSLog(@"%@", _stackedPages);
}

- (void)shiftViewsInArrayLeft
{
    [_stackedPages addObject:_stackedPages.firstObject];
    [_stackedPages removeObjectAtIndex:0];
    NSLog(@"%@", _stackedPages);
}

- (void)resetRecognizer
{
    UIView *topView = _stackedPages[TOP];
    [topView removeGestureRecognizer:_panSwipeRecognizer];
    
    UIView *frontView = _stackedPages[FRONT];
    [frontView addGestureRecognizer:_panSwipeRecognizer];
}

- (void)animateViewsShiftForward
{
    UIView *topView = _stackedPages[TOP];
    UIView *frontView = _stackedPages[FRONT];
    UIView *middleView = _stackedPages[MIDDLE];
    UIView *backView = _stackedPages[BACK];
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         frontView.frame = _initialPositionForTopView;;
                         frontView.alpha = 1;
                     }
                     completion:nil];

    // Take a screenshot of middleView first
    middleView.alpha = 1;
    UIGraphicsBeginImageContext(middleView.bounds.size);
    [middleView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *screenshot = [[UIImageView alloc] initWithImage:img];
    screenshot.frame = middleView.frame;
    middleView.alpha = 0;
    [self.view insertSubview:screenshot aboveSubview:middleView];
    //
    [UIView animateWithDuration:0.5
                          delay:0.1
         usingSpringWithDamping:0.9
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         middleView.frame = _initialPositionForFrontView;
                         screenshot.frame = _initialPositionForFrontView;
                     }
                     completion:^(BOOL finished){
                         middleView.alpha = 1;
                         [screenshot removeFromSuperview];
                     }];
    [UIView animateWithDuration:0.7
                          delay:0.2
         usingSpringWithDamping:0.9
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         backView.frame = _initialPositionForMiddleView;
                         backView.alpha = 0.4;

                     }
                     completion:nil];
    
    // Bring topView close but not quiet backViewFrame
    // Then animate going forward a bit
    [self.view sendSubviewToBack:topView];
    topView.alpha = 0;
    topView.frame = CGRectMake(_initialPositionForBackView.origin.x + 5, _initialPositionForBackView.origin.y - 5, _initialPositionForBackView.size.width - 10, _initialPositionForBackView.size.height - 10);
    [UIView animateWithDuration:0.4
                          delay:0.3
         usingSpringWithDamping:0.9
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         topView.frame = _initialPositionForBackView;
                         topView.alpha = 0.2;
                     }
                     completion:nil];
}

- (void)animateViewsShiftBackward
{
    UIView *topView = _stackedPages[TOP];
    UIView *frontView = _stackedPages[FRONT];
    UIView *middleView = _stackedPages[MIDDLE];
    UIView *backView = _stackedPages[BACK];
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         frontView.frame = _initialPositionForMiddleView;
                         frontView.alpha = 0.4;
                     }
                     completion:nil];
    [UIView animateWithDuration:0.5
                          delay:0.1
         usingSpringWithDamping:0.9
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         middleView.frame = _initialPositionForBackView;
                         middleView.alpha = 0.2;
                     }
                     completion:nil];
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         topView.frame = _initialPositionForFrontView;
                         topView.alpha = 1;
                     }
                     completion:nil];
    
    backView.alpha = 1;
    backView.frame = _initialPositionForTopView;
    [self.view bringSubviewToFront:backView];
}

- (void)handlePanSwipe:(UIPanGestureRecognizer*)recognizer
{
    UIView *frontView = _stackedPages[FRONT];
    UIView *topView = _stackedPages[TOP];
    
    CGPoint translation = [recognizer translationInView:self.view];
    frontView.center = CGPointMake(frontView.center.x, frontView.center.y + translation.y);
    topView.center = CGPointMake(topView.center.x, topView.center.y + translation.y);
    
    [recognizer setTranslation:CGPointZero inView:self.view];

    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"ended");
        CGPoint vel = [recognizer velocityInView:recognizer.view];
        
        if (vel.x < SWIPE_LEFT_THRESHOLD)
        {
            NSLog(@"swipe left");
            [UIView animateWithDuration:0.5
                                  delay:0
                 usingSpringWithDamping:0.9
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 frontView.frame = _initialPositionForFrontView;
                                 frontView.alpha = 1;
                             }
                             completion:nil];
        }
        else if (vel.x > SWIPE_RIGHT_THRESHOLD)
        {
            NSLog(@"swipe right");
            [UIView animateWithDuration:0.5
                                  delay:0
                 usingSpringWithDamping:0.9
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 frontView.frame = _initialPositionForFrontView;
                                 frontView.alpha = 1;
                             }
                             completion:nil];
        }
        else if (vel.y < SWIPE_UP_THRESHOLD)
        {
            // TODO: Detected a swipe up
            NSLog(@"swipe up");
            [self animateViewsShiftForward];
            [self shiftViewsInArrayLeft];
        }
        else if (vel.y > SWIPE_DOWN_THRESHOLD)
        {
            // TODO: Detected a swipe down
            NSLog(@"swipe down");
            [self animateViewsShiftBackward];
            [self shiftViewsInArrayRight];
        }
        else
        {
            // Here, the user lifted the finger/fingers but didn't swipe.
            NSLog(@"lifted finger");
            
            // Check if moving up
            if (frontView.frame.origin.y > _initialPositionForFrontView.origin.y)
            {
                [self animateViewsShiftBackward];
                [self shiftViewsInArrayRight];
            }
            else
            {
                [self animateViewsShiftForward];
                [self shiftViewsInArrayLeft];
            }
        }
    }
    [self resetRecognizer];
}

- (CGFloat)bottomLeftCornerY:(UIView *)view
{
    return view.frame.origin.y + view.frame.size.height;
}

@end

