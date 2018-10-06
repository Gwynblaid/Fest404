// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko

#import "ImageCollectionViewCell.h"

@interface ImageCollectionViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ImageCollectionViewCell


- (void)setImage:(UIImage *)image {
	self.imageView.image = image;
}

- (UIImage *)image {
	return self.imageView.image;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
