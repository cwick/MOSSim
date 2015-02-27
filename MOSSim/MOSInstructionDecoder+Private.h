#import "MOSInstructionDecoder.h"

@interface MOSInstructionDecoder ()

- (MOSPageOffset)decodePageOffset;
- (MOSRelativeAddress)decodeRelativeAddress;
- (MOSAbsoluteAddress)decodeAbsoluteAddress;
- (MOSImmediateValue)decodeImmediateValue;

@end
