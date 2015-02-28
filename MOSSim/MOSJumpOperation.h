#import "MOSOperation.h"
#import "MOSTypes.h"

@class MOSInstruction;

@interface MOSJumpOperation : MOSOperation

- (instancetype)initWithInstruction:(MOSInstruction *)instruction;
- (instancetype)initWithAbsoluteAddress:(MOSAbsoluteAddress)address;
@property(nonatomic, readonly) MOSAbsoluteAddress absoluteAddress;

@end
