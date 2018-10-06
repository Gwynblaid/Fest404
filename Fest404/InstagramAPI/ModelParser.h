// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class InstagramPhotoData;

@interface ModelParser : NSObject

- (NSArray<InstagramPhotoData *> *)parsePhotoResponseFromJSON:(id)json error:(NSError **)error;
- (NSString *)tokenFromJSON:(id)json error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
