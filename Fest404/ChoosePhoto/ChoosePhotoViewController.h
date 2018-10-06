// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ChoosePhotoViewController;

@protocol ChoosePhotoViewControllerDelegate <NSObject>

- (void)choosePhotoViewController:(ChoosePhotoViewController *)viewController didSelectImage:(UIImage *)image;

@end

@interface ChoosePhotoViewController : UIViewController

@property (nonatomic, weak) id<ChoosePhotoViewControllerDelegate> delegate;
@property (nonatomic, strong) id sender;

@end

NS_ASSUME_NONNULL_END
