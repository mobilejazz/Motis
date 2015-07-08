#import "MJChildC.h"

#import "Motis.h"

@implementation MJChildC

+ (NSDictionary*)mts_mapping
{
    return @{@"obj.0.bool": mts_key(boolField),
             @"obj.1.field": mts_key(customField),
             };
}

@end
