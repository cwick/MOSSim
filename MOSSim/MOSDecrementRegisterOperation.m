#import "MOSDecrementRegisterOperation.h"
#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"
#import "MOSUtils.h"

@implementation MOSDecrementRegisterOperation

- (void)execute:(MOSCPU *)cpu {
    cpu.registerValues.y -= 1;
    [cpu.statusRegister setZeroAndNegativeFlagsFromValue:cpu.registerValues.y];
}

@end
