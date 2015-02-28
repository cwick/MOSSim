#import "MOSOperation.h"
#import "MOSTypes.h"

@interface MOSJumpOperation : MOSOperation

- (instancetype)initWithAbsoluteAddress:(MOSAbsoluteAddress)address;
@property(nonatomic, readonly) MOSAbsoluteAddress absoluteAddress;

@end
