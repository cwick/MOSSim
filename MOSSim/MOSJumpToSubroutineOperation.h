#import "MOSOperation.h"
#import "MOSTypes.h"

@interface MOSJumpToSubroutineOperation : MOSOperation

- (instancetype)initWithAbsoluteAddress:(MOSAbsoluteAddress)address;

@end
