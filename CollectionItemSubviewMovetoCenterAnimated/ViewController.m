//
//  ViewController.m
//  CollectionItemSubviewMovetoCenterAnimated
//
//  Created by Stanislav Pletnev on 06.12.16.
//  Copyright © 2016 Anobisoft. All rights reserved.
//

#define spacing 10
#define insets 10
#define figureLargeSize 300

#import "ViewController.h"
#import "CollectionViewCell.h"

@interface ViewController ()

@end

@implementation ViewController {
    __weak IBOutlet UICollectionView *collectionV;
    int count;
    UIView *centeredFigure;
    NSIndexPath *centeredIndexPath;
}

static NSArray *staticColors;
+ (void)initialize {
    [super initialize];
    staticColors = @[[UIColor redColor], [UIColor blueColor], [UIColor yellowColor], [UIColor greenColor], [UIColor cyanColor], [UIColor magentaColor], [UIColor purpleColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    count = 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return count * 2;
}

- (void)figureTap:(UITapGestureRecognizer *)gr {
    centeredIndexPath = [NSIndexPath indexPathForItem:gr.view.tag inSection:0];
    CollectionViewCell *cell = (CollectionViewCell *)[collectionV cellForItemAtIndexPath:centeredIndexPath];
    UICollectionViewLayoutAttributes *attributes = [collectionV layoutAttributesForItemAtIndexPath:centeredIndexPath];
    CGRect realrect = [collectionV convertRect:CGRectMake(attributes.frame.origin.x + cell.figureContainerView.frame.origin.x, attributes.frame.origin.y + cell.figureContainerView.frame.origin.y, cell.figureContainerView.frame.size.width, cell.figureContainerView.frame.size.height) toView:self.view];
    NSLog(@"Real rect %@", NSStringFromCGRect(realrect));
    [cell.figureView removeFromSuperview];
    [self.view addSubview:cell.figureView];
    cell.figureView.frame = realrect;
    NSArray *grcollection = cell.figureView.gestureRecognizers;
    for (UIGestureRecognizer *gri in grcollection) {
        [cell.figureView removeGestureRecognizer:gri];
    }
    UITapGestureRecognizer *ngr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnAnimated:)];
    [cell.figureView addGestureRecognizer:ngr];
    centeredFigure = cell.figureView;
    cell.figureView = nil;
    [self animateView:centeredFigure];
    collectionV.userInteractionEnabled = NO;

}

- (void)returnAnimated:(UITapGestureRecognizer *)gr {
    NSArray *grcollection = gr.view.gestureRecognizers;
    for (UIGestureRecognizer *gri in grcollection) {
        [gr.view removeGestureRecognizer:gri];
    }
    [collectionV reloadItemsAtIndexPaths:@[centeredIndexPath]];

}

- (void)animateView:(UIView *)figure {
    CGPoint center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    NSLog(@"Center %@", NSStringFromCGPoint(center));
    [UIView animateWithDuration:0.8f animations:^{
        figure.backgroundColor = [UIColor blackColor];
        figure.frame = CGRectMake(center.x - figureLargeSize / 2, center.y - figureLargeSize / 2, figureLargeSize, figureLargeSize);
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = staticColors[indexPath.item % staticColors.count];
    
    cell.figureContainerView.backgroundColor = [UIColor clearColor];
    
    if (!cell.figureView) {
        UIView *view;
        if (centeredFigure) {
            collectionV.userInteractionEnabled = YES;
            view = centeredFigure;
            centeredFigure = nil;
            [UIView animateWithDuration:0.8f animations:^{
                [view removeFromSuperview];
                [cell.figureContainerView addSubview:view];
                view.frame = CGRectMake(0, 0, cell.figureContainerView.frame.size.width, cell.figureContainerView.frame.size.height);
            }];
        } else {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.figureContainerView.frame.size.width, cell.figureContainerView.frame.size.height)];
        }
        view.backgroundColor = [UIColor whiteColor];
        [cell.figureContainerView addSubview:view];
        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(figureTap:)];
        [view addGestureRecognizer:gr];
        cell.figureView = view;
    }
    
    cell.figureView.tag = indexPath.item;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        return CGSizeMake((collectionView.frame.size.width - insets * 2 - spacing * (count - 1))  / count , (collectionView.frame.size.height - insets * 2 - spacing) / 2 );
    } else {
        return CGSizeMake((collectionView.frame.size.width - insets * 2 - spacing) / 2, (collectionView.frame.size.height - insets * 2 - spacing * (count - 1)) / count);
    }
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [collectionV.collectionViewLayout invalidateLayout];
}

- (IBAction)addTap:(id)sender {
    if (count < 5) {
        count++;
        [collectionV reloadData];
    }
}

- (IBAction)removeTap:(id)sender {
    if (count > 2) {
        count--;
        [collectionV reloadData];
    }
}

- (IBAction)refreshTap:(id)sender {
    if (centeredFigure) {
        NSArray *grcollection = centeredFigure.gestureRecognizers;
        for (UIGestureRecognizer *gri in grcollection) {
            [centeredFigure removeGestureRecognizer:gri];
        }
    }
    if (centeredIndexPath) [collectionV reloadItemsAtIndexPaths:@[centeredIndexPath]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
