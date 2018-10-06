// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko

#import "ChoosePhotoViewController.h"
#import "ChoosePhotoViewControllerDataSource.h"
#import "ImageCollectionViewCell.h"

@interface ChoosePhotoViewController () <UICollectionViewDelegate, UICollectionViewDataSource, ChoosePhotoViewControllerDataSourceDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) ChoosePhotoViewControllerDataSource *dataSource;

@end

static NSString * const cellIdentifier = @"ImageCollectionViewCell";

@implementation ChoosePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.collectionView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
	self.dataSource = [[ChoosePhotoViewControllerDataSource alloc] init];
	self.dataSource.delegate = self;
	__weak ChoosePhotoViewController *weakSelf = self;
	[self.dataSource loadDataWithCompletion:^{
		dispatch_async(dispatch_get_main_queue(), ^{
			[weakSelf.collectionView reloadData];
		});
	}];
}

- (IBAction)backTapped:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ChoosePhotoViewControllerDataSourceDelegate
- (void)photoDataSource:(ChoosePhotoViewControllerDataSource *)dataSource didChangeImageAtIndexPath:(NSIndexPath *)indexPath {
	[self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.dataSource.imagesCount;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
	cell.image = [self.dataSource imageForIndexPath:indexPath];
	return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[self.delegate choosePhotoViewController:self didSelectImage:[self.dataSource imageForIndexPath:indexPath]];
}

@end
