// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko

#import "ContactsListViewController.h"
#import <Contacts/Contacts.h>
#import "ContactTableViewCell.h"
#import "InstagramApiClient.h"
#import "ChoosePhotoViewController.h"

@interface ContactsListViewController ()<UITableViewDelegate, UITableViewDataSource, ContactTableViewCellDelegate, ChoosePhotoViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray<CNContact *> *contacts;
@property (strong, nonatomic) CNContactStore *store;

@end

static NSString * const cellIdentifier = @"ContactCell";

@implementation ContactsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.store = [CNContactStore new];
	[self.tableView registerNib:[UINib nibWithNibName:@"ContactTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
	[self updateContactsList];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)updateContactsList {
	__weak ContactsListViewController *weakSelf = self;
	[self requestContactsWithCompletion:^(NSArray<CNContact *> *contacts) {
		weakSelf.contacts = contacts;
		dispatch_async(dispatch_get_main_queue(), ^{
			[weakSelf.tableView reloadData];
		});
	} failure:^(NSError *error) {
		NSLog(@"%@", error);
	}];
}


- (void)requestContactsWithCompletion:(void (^)(NSArray<CNContact*>*))completion
                              failure:(void (^)(NSError*))failure{
	__weak ContactsListViewController *weakSelf = self;
    [self.store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if(granted) {
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactImageDataAvailableKey];
            NSString *containerId = weakSelf.store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSArray<CNContact *> *contacts = [weakSelf.store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:nil];
            if(completion) {
                completion(contacts);
            }
        } else {
            NSError *err = error == nil ? [NSError errorWithDomain:@"ru.objctoswift.contacts" code:101 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Permissions not granted", @"")}] : error;
            if(failure) {
                failure(err);
            }
        }
    }];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell configureWithContact:self.contacts[indexPath.row]];
	cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contacts.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if([segue.identifier isEqualToString:@"ChoosePhoto"]) {
		ChoosePhotoViewController *vc = (ChoosePhotoViewController *)segue.destinationViewController;
		vc.delegate = self;
		vc.sender = sender;
	}
}

#pragma mark - ContactTableViewCellDelegate
- (void)contactCellChangePhotoTapped:(ContactTableViewCell *)cell {
    __weak ContactsListViewController *weakSelf = self;
    UIViewController *authVC = [[InstagramApiClient defaultClient] authVCWithCompletion:^(UIViewController * vc) {
        [vc dismissViewControllerAnimated:YES completion:nil];
        [weakSelf contactCellChangePhotoTapped:cell];
    }];
    if(authVC) {
        [self presentViewController:authVC animated:YES completion:nil];
    } else {
        [self performSegueWithIdentifier:@"ChoosePhoto" sender:[self.tableView indexPathForCell:cell]];
    }
}

#pragma mark - ChoosePhotoViewControllerDelegate
- (void)choosePhotoViewController:(ChoosePhotoViewController *)viewController didSelectImage:(UIImage *)image {
	CNContact *contact = self.contacts[[viewController.sender row]];
	CNMutableContact *mutContact = [contact mutableCopy];
	mutContact.imageData = UIImageJPEGRepresentation(image, 1);
	CNSaveRequest *request = [[CNSaveRequest alloc] init];
	[request updateContact:mutContact];
	[self.store executeSaveRequest:request error:nil];
	[self updateContactsList];
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
