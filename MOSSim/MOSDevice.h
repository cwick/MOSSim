#include "MOSTypes.h"

@protocol MOSDevice <NSObject>

- (MOSWord)readWordFromAddress:(MOSAbsoluteAddress)address;
- (void)writeWord:(MOSWord)value toAddress:(MOSAbsoluteAddress)address;

@end