// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko

#import "InstagramApiClient.h"
#import <UIKit/UIKit.h>
#import "ModelParser.h"
#import "NSDictionary+Requests.h"
#import "InstagramApiClient+Private.h"

static NSString *const ClientID = @"a73c914cc080435d87a94311cff47062";
static NSString *const ClientSecret = @"df66ea65099a46d7b2829bddcd1c7e14";
static NSString *const redirectURL = @"http://testinst.app";

@interface InstagramApiClient()

@property (nonatomic, strong) ModelParser *parser;

@end

@implementation InstagramApiClient

+ (instancetype)defaultClient {
    static InstagramApiClient *defaultClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultClient = [InstagramApiClient new];
    });
    return defaultClient;
}

- (id)init {
	self = [super init];
	self.parser = [ModelParser new];
	return self;
}

//- (void)requestMyPhotosWithSuccess:(void (^)(NSArray<InstagramPhotoData *> *))succeeded
//                           failure:(void (^)(NSError *))failure {
//    if(!self.token.length) {
//        if(failure) {
//            failure([NSError errorWithDomain:@"mydomain" code:101 userInfo:@{NSLocalizedDescriptionKey: @"You are not authorized"}]);
//        }
//        return;
//    }
//    NSString *requestString = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/media/recent?access_token=%@", self.token];
//    NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithURL:[NSURL URLWithString:requestString] completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
//        if(error) {
//            failure(error);
//            return;
//        }
//        NSError *err = nil;
//        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
//        NSArray *result;
//        if(!err) {
//            result = [self.parser parsePhotoResponseFromJSON:json error:&err];
//        }
//        if(err) {
//            failure(err);
//        } else {
//            succeeded(result);
//        }
//    }];
//    [task resume];
//}

- (void)loadImageFromURL:(NSString *)urlString
				 success:(void (^)(UIImage *))succeded
				 failure:(void (^)(NSError *))failure {
	NSURL *url = [NSURL URLWithString:urlString];
	if(!url) {
		if(failure) {
			failure([NSError errorWithDomain:@"mydomain" code:102 userInfo:@{NSLocalizedDescriptionKey : @"Url is not valid"}]);
		}
		return;
	}
	NSURLSessionDataTask *dataTask = [NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		if(error || !data.length) {
			if(failure) {
				failure(error);
			}
		} else {
			if(succeded) {
				succeded([UIImage imageWithData:data]);
			}
		}
	}];
	[dataTask resume];
}

- (UIViewController *)authVCWithCompletion:(ViewControllerCompletion)completion {
    if(self.token) {
        return nil;
    }
    InstagramAuthorizationViewController *vc = [InstagramAuthorizationViewController new];
    vc.clientID = ClientID;
    vc.redirectURI = [NSURL URLWithString:redirectURL];
	__weak InstagramApiClient *weakSelf = self;
    [vc setCatchToken:^(NSString * code, void (^ completion)(void)) {
        [weakSelf requestTokenWithCode:code success:^(NSString *token) {
            weakSelf.token = token;
            if(completion) {
                completion();
            }
        } failure:^(NSError * error) {
            NSLog(@"%@", error);
            if(completion) {
                completion();
            }
        }];
    }];
    vc.completion = completion;
    return vc;
}

- (void)requestTokenWithCode:(NSString *)code
					 success:(void (^)(NSString *))succeeded
					 failure:(void (^)(NSError *))failure {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"]];
	NSDictionary *postParams = @{
								 @"client_id" : ClientID,
								 @"client_secret" : ClientSecret,
								 @"grant_type" : @"authorization_code",
								 @"redirect_uri" : redirectURL,
								 @"code" : code,
								 };
	NSString *dataString = postParams.getParams;
	request.HTTPBody = [dataString dataUsingEncoding:NSUTF8StringEncoding];
	request.HTTPMethod = @"POST";
	NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		if(error) {
			failure(error);
			return;
		}
		NSError *err = nil;
		id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
		NSString *result;
		if(!err) {
			result = [self.parser tokenFromJSON:json error:&err];
		}
		if(err) {
			failure(err);
		} else {
			succeeded(result);
		}
	}];
	[task resume];
}

@end


