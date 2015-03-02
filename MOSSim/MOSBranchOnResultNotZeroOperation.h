#import "MOSOperation.h"
#import "MOSTypes.h"

@class MOSInstruction;

@interface MOSBranchOnResultNotZeroOperation : MOSOperation

- (instancetype)initWithRelativeAddress:(MOSRelativeAddress)address;

@end
