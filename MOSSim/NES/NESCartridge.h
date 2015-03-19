#import "MOSTypes.h"

@interface NESCartridge : NSObject

- (MOSWord)readWordFromAddress:(MOSAbsoluteAddress)address;
- (void)writeWord:(MOSWord)value toAddress:(MOSAbsoluteAddress)address;

@end