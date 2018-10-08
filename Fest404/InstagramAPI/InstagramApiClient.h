// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko

#import <Foundation/Foundation.h>
#import "InstagramAuthorizationViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class InstagramPhotoData;

@interface InstagramApiClient : NSObject

+ (instancetype)defaultClient;

//- (void)requestMyPhotosWithSuccess:(void (^)(NSArray<InstagramPhotoData *> *))succeeded
//                           failure:(void (^)(NSError *))failure;
- (void)loadImageFromURL:(NSString *)urlString
				 success:(void (^)(UIImage *))succeded
				 failure:(void (^)(NSError *))failure;

- (UIViewController *)authVCWithCompletion:(ViewControllerCompletion)completion;

@end

NS_ASSUME_NONNULL_END
