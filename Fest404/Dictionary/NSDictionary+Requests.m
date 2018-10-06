// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko

#import "NSDictionary+Requests.h"

@implementation NSDictionary(Requests)

- (NSString *)getParams {
	NSMutableString *mutResult = [NSMutableString new];
	for(NSString *key in [self allKeys]) {
		[mutResult appendFormat:@"%@=%@&", key, self[key]];
	}
	[mutResult deleteCharactersInRange:NSMakeRange([mutResult length]-1, 1)];
	return [NSString stringWithString:mutResult];
}

@end
