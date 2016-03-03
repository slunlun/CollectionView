//
//  ViewController.m
//  CollectionView
//
//  Created by EShi on 3/3/16.
//  Copyright © 2016 Eren. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic, strong) UIView *dragMoveView;
@property(nonatomic) CGPoint beginPoint;
@property(nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property(nonatomic) CGFloat initHeight;
@property(nonatomic) CGFloat maxHeight;
@property(nonatomic) CGFloat beginHeight;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _dragMoveView = [[UIView alloc] init];
    _dragMoveView.backgroundColor = [UIColor grayColor];
    _dragMoveView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panViewResponse:)];
    [_dragMoveView addGestureRecognizer:pan];
    self.initHeight = 50.0f;
    
    [self.view addSubview:_dragMoveView];
    NSDictionary *viewDict = @{@"dragMoveView":_dragMoveView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dragMoveView]|" options:0 metrics:nil views:viewDict]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_dragMoveView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.dragMoveView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.initHeight];
    [self.view addConstraint:self.heightConstraint];
}

-(void) panViewResponse:(UIPanGestureRecognizer *) panGesture
{
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        self.beginPoint = [panGesture locationInView:self.view];
        self.maxHeight = (self.view.frame.size.height * 2)/3;
        self.beginHeight = self.dragMoveView.frame.size.height;
    }else if(panGesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint newPoint = [panGesture locationInView:self.view];
        CGFloat newY = self.beginPoint.y - newPoint.y;
        [self.view removeConstraint:self.heightConstraint];
        
        if (newY + self.beginHeight <= self.initHeight) {
            self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.dragMoveView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.initHeight];

        }else if(newY + self.beginHeight >= self.maxHeight)
        {
            self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.dragMoveView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.maxHeight];

        }else
        {
            self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.dragMoveView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:newY + self.beginHeight];
        }

        [self.view addConstraint:self.heightConstraint];
        [self.view layoutIfNeeded];
    }else if(panGesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint newPoint = [panGesture locationInView:self.view];
        CGFloat newY = self.beginPoint.y - newPoint.y;
        [self.view removeConstraint:self.heightConstraint];
        
  
        if (newY < 0) { // down
            self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.dragMoveView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.initHeight];
        }else if(newY > 0) // up
        {
            self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.dragMoveView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.maxHeight];
        }
        
        

        [UIView animateWithDuration:0.5 animations:^{
      
            [self.view addConstraint:self.heightConstraint];
            [self.view layoutIfNeeded];
         
            
        } completion:^(BOOL finished) {
            
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
