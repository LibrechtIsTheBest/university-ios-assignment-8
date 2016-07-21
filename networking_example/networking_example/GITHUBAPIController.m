#import "GITHUBAPIController.h"
#import <AFNetworking/AFNetworking.h>
#import "Repository.h"


static NSString *const kBaseAPIURL = @"https://api.github.com";


@interface GITHUBAPIController ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end


@implementation GITHUBAPIController

#pragma mark - Object lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *apiURL = [NSURL URLWithString:kBaseAPIURL];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:apiURL];
    }

    return self;
}

+ (instancetype)sharedController
{
    static GITHUBAPIController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[GITHUBAPIController alloc] init];
    });

    return sharedController;
}

#pragma mark - Inner requests

- (void)getInfoForUser:(NSString *)userName
    success:(void (^)(NSDictionary *))success
    failure:(void (^)(NSError *))failure
{
    NSString *requestString = [[NSString stringWithFormat:@"users/%@", userName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    [self.sessionManager
        GET:requestString
        parameters:nil
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            if (success) {
                NSLog(@"%@", responseObject);
                success(responseObject);
            }
        }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
}

- (void)getReposForUser:(NSString *)userName
                success:(void (^)(NSArray *))success
                failure:(void (^)(NSInteger responseStatusCode, NSError *))failure
{
    NSString *requestString = [[NSString stringWithFormat:@"users/%@/repos", userName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self.sessionManager
     GET:requestString
     parameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable responseObject) {
         
         if (success) {
             success(responseObject);
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         NSInteger responseStatusCode = ((NSHTTPURLResponse *)task.response).statusCode;
         failure(responseStatusCode, error);
     }];
}

- (void)getCommitsInfoForUser:(NSString *)userName
                         repo:(NSString *)repo
                      success:(void (^)(NSArray *))success
                      failure:(void (^)(NSInteger responseStatusCode, NSError *))failure
{
    NSString *requestString = [[NSString stringWithFormat:@"repos/%@/%@/commits", userName, repo] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self.sessionManager
     GET:requestString
     parameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable responseObject) {
         
         if (success) {
             success(responseObject);
         }
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         if (failure) {
             NSInteger responseStatusCode = ((NSHTTPURLResponse *)task.response).statusCode;
             failure(responseStatusCode, error);
         }
     }];
}

#pragma mark - Public methods

- (void)getAvatarForUser:(NSString *)userName
    success:(void (^)(NSURL *))success
    failure:(void (^)(NSError *))failure
{
    [self getInfoForUser:userName
        success:^(NSDictionary *userInfo) {
            NSString *avatarURLString = userInfo[@"avatar_url"];
            NSURL *avatarURL = [NSURL URLWithString:avatarURLString];
            success(avatarURL);
        }
        failure:^(NSError *error) {
            failure(error);
        }];
}

- (void)getReposInfoForUser:(NSString *)userName
                    success:(void (^)(NSArray *reposInfo))success
                    failure:(void (^)(NSInteger responseStatusCode, NSError *error))failure
{
    [self getReposForUser:userName success:^(NSArray *repos) {
        
        NSMutableArray *mutableReposInfo = [[NSMutableArray alloc] init];
        
        if (success) {
            
            dispatch_group_t group = dispatch_group_create();
            for (NSDictionary *repo in repos) {
                
                dispatch_group_enter(group);
                NSString *repoName = repo[@"name"];
                
                [self getCommitsInfoForUser:userName repo:repoName success:^(NSArray *commits) {
                    
                    NSString *author = commits[0][@"commit"][@"author"][@"name"];
                    NSString *date = commits[0][@"commit"][@"author"][@"date"];
                    
                    [mutableReposInfo addObject:[[Repository alloc] initWithName:repoName authorName:author dateString:date]];
                    dispatch_group_leave(group);
                    
                } failure:^(NSInteger responseStatusCode, NSError *error) {
                    
                    [mutableReposInfo addObject:[[Repository alloc] initWithName:repoName]];
//                    if (failure) {
//                        failure(responseStatusCode, error);
//                    }
                    dispatch_group_leave(group);
                }];
            }
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                
                success([NSArray arrayWithArray:mutableReposInfo]);
            });
        }
        
    } failure:^(NSInteger responseStatusCode, NSError *error) {
        
        if (failure) {
            failure(responseStatusCode, error);
        }
    }];
}

@end
















