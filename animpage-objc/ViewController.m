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
    
    _outOfViewPositionForFP = CGRectMake(0, 0, 100, 100);//CGRectMake( _initialPositionForFP.origin.x, -(_initialPositionForFP.origin.y + _initialPositionForFP.size.height), _initialPositionForFP.size.width, _initialPositionForFP.size.height);
    
    _triggerHorizontalLine = self.view.frame.size.height*(0.9);
    [_dragView setUserInteractionEnabled:YES];

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragView:)];
    [_dragView addGestureRecognizer:panGesture];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown];
    [_dragView addGestureRecognizer:swipeGesture];
}

- (void)swipeView:(UISwipeGestureRecognizer*)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.9
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             sender.view.frame = _outOfViewPositionForFP;
                         }
                         completion:nil];
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
