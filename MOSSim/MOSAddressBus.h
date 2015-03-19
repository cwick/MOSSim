#import "MOSDevice.h"

@protocol MOSAddressBus <MOSDevice>

- (void)loadBinaryImage:(NSData *)data;

@end