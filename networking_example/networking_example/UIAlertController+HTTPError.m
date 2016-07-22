
#import "UIAlertController+HTTPError.h"

@implementation UIAlertController (HTTPError)

+ (instancetype)dummyAlertControllerWithHTTPErrorCode:(NSInteger)responseStatusCode
{
    UIAlertController *alertController;
    
    if (responseStatusCode == 404) {
        
        alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"User not found" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
    }
    else if (responseStatusCode == 0) {
        
        alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"The Internet connection appears to be offline" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
    }
    else {
        alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Try again later" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
    }
    
    return alertController;
}

@end
