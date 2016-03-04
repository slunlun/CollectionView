//
//  ViewController.m
//  CollectionView
//
//  Created by EShi on 3/3/16.
//  Copyright © 2016 Eren. All rights reserved.
//

#import "ViewController.h"
#import "SWTestQuestionCell.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UIView *dragMoveView;
@property(nonatomic) CGPoint beginPoint;
@property(nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property(nonatomic) CGFloat initHeight;
@property(nonatomic) CGFloat maxHeight;
@property(nonatomic) CGFloat beginHeight;
@property(nonatomic, strong) UICollectionView *contentCollectionView;
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
    self.initHeight = 80.0f;
    
    [self.view addSubview:_dragMoveView];
    NSDictionary *viewDict = @{@"dragMoveView":_dragMoveView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dragMoveView]|" options:0 metrics:nil views:viewDict]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_dragMoveView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.dragMoveView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.initHeight];
    [self.view addConstraint:self.heightConstraint];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(50.0, 50.0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 0.0f;
    
    _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    _contentCollectionView.dataSource = self;
    _contentCollectionView.delegate = self;
    _contentCollectionView.bounces = YES;
    [_contentCollectionView setShowsHorizontalScrollIndicator:NO];
    [_contentCollectionView setShowsVerticalScrollIndicator:NO];

    
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SWTestQuestionCell" bundle:nil] forCellWithReuseIdentifier:@"SW_QUESTION_NUM_CELL"];
     _contentCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dragMoveView addSubview:_contentCollectionView];
    viewDict = @{@"collectionView":_contentCollectionView};
    [self.dragMoveView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:viewDict]];
    [self.dragMoveView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(30)-[collectionView]-|" options:0 metrics:nil views:viewDict]];
    
   // [_contentCollectionView addGestureRecognizer:pan];
    
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

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 45;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SWTestQuestionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SW_QUESTION_NUM_CELL" forIndexPath:indexPath];
    NSString * stringTitle = [NSString stringWithFormat:@"%ld", (long)(indexPath.row + 1)];
    NSLog(@"Should is %@", stringTitle);
    [cell.SWQuestionNumLabel setText:stringTitle];
    NSLog(@"The text is %@ and textLabel is %@", cell.SWQuestionNumLabel.text, cell.SWQuestionNumLabel);
    [cell.SWQuestionNumLabel setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.6]];
    cell.SWQuestionNumLabel.layer.cornerRadius = 24.0f;
    cell.SWQuestionNumLabel.layer.masksToBounds = YES;
    [cell.SWQuestionNumLabel.layer setBorderWidth:1.0];
    
    return cell;
}

@end
