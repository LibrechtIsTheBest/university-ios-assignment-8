#import <Foundation/Foundation.h>


@interface GITHUBAPIController : NSObject
+ (instancetype)sharedController;

- (void)getAvatarForUser:(NSString *)userName
    success:(void(^)(NSURL *))success
    failure:(void(^)(NSError *))failure;

- (void)getReposInfoForUser:(NSString *)userName
                success:(void (^)(NSArray *reposInfo))success
                failure:(void (^)(NSInteger responseStatusCode, NSError *error))failure;

@end
