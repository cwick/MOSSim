#import "MOSDevice.h"

@interface MOSReadWriteMemory : NSObject<MOSDevice>

- (void)loadBinaryImage:(NSData *)data;

@end