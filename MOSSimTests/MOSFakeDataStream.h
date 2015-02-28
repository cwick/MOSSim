#import <Foundation/Foundation.h>
#import "MOSTypes.h"

@interface MOSFakeDataStream : NSObject<MOSDataStream>

@property(nonatomic) NSArray* data;
@property(nonatomic) NSInteger location;

@end
