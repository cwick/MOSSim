#import "MOSCompareOperation.h"
#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"
#import "MOSUtils.h"

@implementation MOSCompareOperation

- (id)initWithInstruction:(MOSInstruction *)instruction register:(NSString *)reg {
    self = [super initWithInstruction:instruction];
    if (self) {
        _registerToCompare = reg;
    }

    return self;
}

- (void)execute:(MOSCPU *)cpu {
    MOSImmediateValue operand = self.instruction.immediateValue;
    MOSRegisterValue registerValue = (MOSRegisterValue) [[cpu.registerValues valueForKey:self.registerToCompare] integerValue];
    MOSWord difference = registerValue - operand;

    [cpu.statusRegister setZeroAndNegativeFlagsFromValue:difference];
    cpu.statusRegister.carryFlag = (registerValue >= operand);
}

@end
