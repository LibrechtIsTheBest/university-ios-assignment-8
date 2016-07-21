
#import <Foundation/Foundation.h>

@interface Repository : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *date;

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name authorName:(NSString *)author dateString:(NSString *)date;

@end
