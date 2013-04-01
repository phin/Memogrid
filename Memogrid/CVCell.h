//
//  CVCell.h
//  Memogrid
//
//  Created by Seraphin Hochart on 2013-03-31.
//  Copyright (c) 2013 Seraphin Hochart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NSString *mode;
@property (nonatomic) int level;

@end
