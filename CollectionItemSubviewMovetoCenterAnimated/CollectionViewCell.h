//
//  CollectionViewCell.h
//  Constr
//
//  Created by Stanislav Pletnev on 07.12.16.
//  Copyright © 2016 Academ Media Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *figureContainerView;
@property (weak, nonatomic) UIView *figureView;

@end
