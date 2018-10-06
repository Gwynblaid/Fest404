// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko

#import "ContactTableViewCell.h"
#import <Contacts/Contacts.h>

@interface ContactTableViewCell()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *surenameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation ContactTableViewCell

- (UIImage *)defaultAvatar {
    return [UIImage imageNamed:@"default_avatar"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithContact:(CNContact *)contact {
    self.nameLabel.text = contact.givenName;
    self.surenameLabel.text = contact.familyName;
    CNLabeledValue<CNPhoneNumber*> *number = [contact.phoneNumbers firstObject];
    self.phoneNumberLabel.text = number.value.stringValue;
    if(contact.imageDataAvailable) {
        self.avatarImageView.image = [UIImage imageWithData:contact.imageData];
    } else {
        self.avatarImageView.image = self.defaultAvatar;
    }
}

- (IBAction)changePhotoTapped:(id)sender {
	[self.delegate contactCellChangePhotoTapped:self];
}

@end
