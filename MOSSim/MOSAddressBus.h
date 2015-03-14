#include "MOSTypes.h"

@protocol MOSAddressBus

- (MOSWord)readWordFromAddress:(MOSAbsoluteAddress)address;
- (void)writeWord:(MOSWord)value toAddress:(MOSAbsoluteAddress)address;
- (void)loadBinaryImage:(NSData *)data;

@end