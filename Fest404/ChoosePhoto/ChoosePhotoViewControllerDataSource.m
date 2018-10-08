// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko

#import "ChoosePhotoViewControllerDataSource.h"
#import "InstagramApiClient.h"
#import "InstagramPhotoData.h"
#import "Fest404-Swift.h"

@interface ObjectContainer : NSObject

@property (nonatomic, strong) InstagramPhotoData *data;
@property (atomic, strong) UIImage *image;

- (id)initWithData:(InstagramPhotoData *)data;

@end

@implementation ObjectContainer

- (id)initWithData:(InstagramPhotoData *)data {
	self = [super init];
	self.data = data;
	return self;
}

@end

@interface ChoosePhotoViewControllerDataSource()

@property (atomic, strong) NSArray<ObjectContainer *> *dataArray;
@property (nonatomic, strong) UIImage *defaultImage;

@end

@implementation ChoosePhotoViewControllerDataSource

- (id)init {
	self = [super init];
	self.defaultImage = [UIImage imageNamed:@"loading"];
	return self;
}

- (void)loadDataWithCompletion:(void (^)(void)) completion {
	InstagramApiClient *instagramClient = [InstagramApiClient defaultClient];
	[instagramClient requestMyPhotosWithSuccess:^(NSArray<InstagramPhotoData *> * result) {
		NSMutableArray *mutArray = [NSMutableArray new];
		for(InstagramPhotoData *instData in result) {
			[mutArray addObject:[[ObjectContainer alloc] initWithData:instData]];
		}
		self.dataArray = [NSArray arrayWithArray:mutArray];
		if(completion) {
			completion();
		}
	} failure:^(NSError * error) {
		if(completion) {
			completion();
		}
	}];
}

- (NSInteger)imagesCount {
	return self.dataArray.count;
}

- (UIImage *)imageForIndexPath:(NSIndexPath *)indexPath {
	__weak ObjectContainer *object = self.dataArray[indexPath.row];
	__weak ChoosePhotoViewControllerDataSource *weakSelf = self;
	if(object.image) {
		return object.image;
	} else {
		[InstagramApiClient.defaultClient loadImageFromURL:object.data.imageURLString success:^(UIImage * image) {
			object.image = image;
			dispatch_async(dispatch_get_main_queue(), ^{
				[weakSelf.delegate photoDataSource:weakSelf didChangeImageAtIndexPath:indexPath];
			});
		} failure:^(NSError * error) {
			
		}];
	}
	return self.defaultImage;
}

@end
