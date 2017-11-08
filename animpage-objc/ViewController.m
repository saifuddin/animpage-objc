//
//  ViewController.m
//  animpage-objc
//
//  Created by Ahmad Saifuddin on 11/6/17.
//  Copyright © 2017 Ahmad Saifuddin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *dragView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *behindView;
@property (nonatomic) CGFloat triggerHorizontalLine;
@property (nonatomic) CGRect initialPositionForFP;
@property (nonatomic) CGRect initialPositionForMP;
@property (nonatomic) CGRect initialPositionForLP;
@property (nonatomic) CGRect outOfViewPositionForFP;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _initialPositionForFP = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 100);
    _dragView.frame = _initialPositionForFP;
    _dragView.alpha = 0.5;
    _initialPositionForMP = CGRectMake(0 + 20, 70, self.view.frame.size.width - 20 - 20, self.view.frame.size.height - 70 - 70);
    _middleView.frame = _initialPositionForMP;
    _middleView.alpha = 0.5;
    _initialPositionForLP = CGRectMake(0 + 20 + 20, 50, self.view.frame.size.width - 20 - 20 - 20 - 20, self.view.frame.size.height - 70 - 70 - 70);
    _behindView.frame = _initialPositionForLP;
    _behindView.alpha = 0.5;
    
    _outOfViewPositionForFP = CGRectMake( _initialPositionForFP.origin.x, -(_initialPositionForFP.origin.y + _initialPositionForFP.size.height), _initialPositionForFP.size.width, _initialPositionForFP.size.height);
    
    _triggerHorizontalLine = self.view.frame.size.height*(0.9);
    [_dragView setUserInteractionEnabled:YES];

//    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panned:)];
//    UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
//    [pan requireGestureRecognizerToFail:swipe];
//    swipe.direction = (UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown);
//
//    [_dragView addGestureRecognizer:pan];
//    [_dragView addGestureRecognizer:swipe];
//    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
//    swipeUp.direction = (UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown);
//    [_dragView addGestureRecognizer:swipeUp];
//
//    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
//    [_dragView addGestureRecognizer:swipeDown];
//
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
//    [panGesture requireGestureRecognizerToFail:swipeUp];
//    [panGesture requireGestureRecognizerToFail:swipeDown];
//    [_dragView addGestureRecognizer:panGesture];
    [self setupRecognizer];
}

- (void)setupRecognizer
{
    UIPanGestureRecognizer* panSwipeRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanSwipe:)];
    // Here you can customize for example the minimum and maximum number of fingers required
    panSwipeRecognizer.minimumNumberOfTouches = 1;
    [_dragView addGestureRecognizer:panSwipeRecognizer];
}

#define SWIPE_UP_THRESHOLD -1000.0f
#define SWIPE_DOWN_THRESHOLD 1000.0f
#define SWIPE_LEFT_THRESHOLD -1000.0f
#define SWIPE_RIGHT_THRESHOLD 1000.0f

- (void)handlePanSwipe:(UIPanGestureRecognizer*)recognizer
{
    // TODO: Here, you should translate your target view using this translation
    CGPoint translation = [recognizer translationInView:self.view];
    _dragView.center = CGPointMake(_dragView.center.x, _dragView.center.y + translation.y);//CGPoint(x: viewDrag.center.x + translation.x, y: viewDrag.center.y + translation.y)
    [recognizer setTranslation:CGPointZero inView:self.view];
    // But also, detect the swipe gesture

    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"ended");
        CGPoint vel = [recognizer velocityInView:recognizer.view];
        
        if (vel.y < SWIPE_UP_THRESHOLD)
        {
            // TODO: Detected a swipe up
            NSLog(@"swipe up");
            CGFloat bottomLeftCorner = _dragView.frame.origin.y + _dragView.frame.size.height;
            if (bottomLeftCorner < _triggerHorizontalLine) {
                NSLog(@"should bring forward");
                [UIView animateWithDuration:0.7
                                      delay:0
                     usingSpringWithDamping:0.9
                      initialSpringVelocity:0
                                    options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     _dragView.frame = _outOfViewPositionForFP;
                                 }
                                 completion:nil];
                [self moveViewsToForeground];
            }
            else {
                NSLog(@"bring to back");
                [UIView animateWithDuration:0.5
                                      delay:0
                     usingSpringWithDamping:0.9
                      initialSpringVelocity:0
                                    options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     _middleView.frame = _initialPositionForMP;
                                 }
                                 completion:nil];
                [UIView animateWithDuration:0.5
                                      delay:0.1
                     usingSpringWithDamping:0.9
                      initialSpringVelocity:0
                                    options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     _behindView.frame = _initialPositionForLP;
                                 }
                                 completion:nil];
            }
        }
        else if (vel.y > SWIPE_DOWN_THRESHOLD)
        {
            // TODO: Detected a swipe down
            NSLog(@"swipe down");
        }
        else
        {
            NSLog(@"lifted finger");
            [UIView animateWithDuration:0.7
                                  delay:0
                 usingSpringWithDamping:0.9
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 _dragView.frame = _outOfViewPositionForFP;
                             }
                             completion:nil];
            [self moveViewsToForeground];
            // TODO:
            // Here, the user lifted the finger/fingers but didn't swipe.
            // If you need you can implement a snapping behaviour, where based on the location of your         targetView,
            // you focus back on the targetView or on some next view.
            // It's your call
        }
    }
}

- (void)moveViewsToForeground
{
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _middleView.frame = _initialPositionForFP;
                     }
                     completion:nil];
    [UIView animateWithDuration:0.5
                          delay:0.1
         usingSpringWithDamping:0.9
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _behindView.frame = _initialPositionForMP;
                     }
                     completion:nil];
}

- (void)swipeView:(UISwipeGestureRecognizer*)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        [UIView animateWithDuration:0.7
                              delay:0
             usingSpringWithDamping:0.9
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _dragView.frame = _outOfViewPositionForFP;
                         }
                         completion:nil];
    }
    else if (sender.direction == UISwipeGestureRecognizerDirectionDown)
    {
        NSLog(@"down");
    }
}

- (void)dragView:(UIPanGestureRecognizer*)sender
{
    CGPoint translation = [sender translationInView:self.view];
    _dragView.center = CGPointMake(_dragView.center.x, _dragView.center.y + translation.y);//CGPoint(x: viewDrag.center.x + translation.x, y: viewDrag.center.y + translation.y)
    [sender setTranslation:CGPointZero inView:self.view];
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"began");
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        NSLog(@"changed");
        CGFloat bottomLeftCorner = _dragView.frame.origin.y + _dragView.frame.size.height;
        if (bottomLeftCorner < _triggerHorizontalLine) {
            NSLog(@"should bring forward");
            [UIView animateWithDuration:0.5
                                  delay:0
                 usingSpringWithDamping:0.9
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 _middleView.frame = _initialPositionForFP;
                             }
                             completion:nil];
            [UIView animateWithDuration:0.5
                                  delay:0.1
                 usingSpringWithDamping:0.9
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 _behindView.frame = _initialPositionForMP;
                             }
                             completion:nil];
        }
        else {
            NSLog(@"bring to back");
            [UIView animateWithDuration:0.5
                                  delay:0
                 usingSpringWithDamping:0.9
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 _middleView.frame = _initialPositionForMP;
                             }
                             completion:nil];
            [UIView animateWithDuration:0.5
                                  delay:0.1
                 usingSpringWithDamping:0.9
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 _behindView.frame = _initialPositionForLP;
                             }
                             completion:nil];
        }
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"ended");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
