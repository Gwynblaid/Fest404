// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko

#import <UIKit/UIKit.h>
@class CNContact;
@class ContactTableViewCell;

@protocol ContactTableViewCellDelegate <NSObject>

- (void)contactCellChangePhotoTapped:(ContactTableViewCell *)cell;

@end

@interface ContactTableViewCell : UITableViewCell

- (void)configureWithContact:(CNContact *)contact;

@property (nonatomic, weak) id<ContactTableViewCellDelegate> delegate;

@end
