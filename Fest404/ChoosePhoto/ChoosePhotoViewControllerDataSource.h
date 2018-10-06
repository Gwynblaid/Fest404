// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UIImage;
@class ChoosePhotoViewControllerDataSource;

@protocol ChoosePhotoViewControllerDataSourceDelegate <NSObject>

- (void)photoDataSource:(ChoosePhotoViewControllerDataSource *)dataSource didChangeImageAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ChoosePhotoViewControllerDataSource : NSObject

- (void)loadDataWithCompletion:(void (^)(void)) completion;

- (NSInteger)imagesCount;
- (UIImage *)imageForIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, weak) id<ChoosePhotoViewControllerDataSourceDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
