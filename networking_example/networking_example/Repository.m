
#import "Repository.h"

@implementation Repository

- (instancetype)initWithName:(NSString *)name
{
    self = [self initWithName:name authorName:nil dateString:nil];
    return self;
}

- (instancetype)initWithName:(NSString *)name authorName:(NSString *)author dateString:(NSString *)date
{
    if (self = [super init]) {
        
        _name = name;
        _author = author;
        _date = date;
    }
    return self;
}

@end
