// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko

#import "ModelParser.h"
#import "InstagramPhotoData.h"

@implementation ModelParser

- (NSArray<InstagramPhotoData *> *)parsePhotoResponseFromJSON:(id)json error:(NSError **)error {
	NSArray *dataArray = json[@"data"];
	NSMutableArray *mutArray = [NSMutableArray new];
	for(NSDictionary *dic in dataArray) {
		InstagramPhotoData *data = [InstagramPhotoData new];
		data.imageURLString = dic[@"images"][@"standard_resolution"][@"url"];
		[mutArray addObject:data];
	}
	return [NSArray arrayWithArray:mutArray];
}

- (NSString *)tokenFromJSON:(NSDictionary *)json error:(NSError **)error {
	NSLog(@"%@", json);
	return json[@"access_token"];
}

@end
