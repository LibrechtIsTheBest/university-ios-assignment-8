
#import <Foundation/Foundation.h>

@interface UIAlertController (HTTPError)

+ (instancetype)dummyAlertControllerWithHTTPErrorCode:(NSInteger)responseStatusCode;

@end
