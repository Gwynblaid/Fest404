// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^TokenCompletion)(NSString *, void (^)(void));
typedef void (^ViewControllerCompletion)(UIViewController *);

@interface InstagramAuthorizationViewController : UIViewController

@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSURL *redirectURI;
@property (nonatomic, copy) TokenCompletion catchToken;
@property (nonatomic, copy) ViewControllerCompletion completion;

@end

NS_ASSUME_NONNULL_END
