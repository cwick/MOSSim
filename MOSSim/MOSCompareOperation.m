#import "MOSCompareOperation.h"
#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"
#import "MOSUtils.h"

@implementation MOSCompareOperation

- (void)execute:(MOSCPU *)cpu {
    MOSImmediateValue value = self.instruction.immediateValue;
    cpu.statusRegister.zeroFlag = (value == cpu.registerValues.x);
    cpu.statusRegister.carryFlag = (cpu.registerValues.x >= value);
    cpu.statusRegister.negativeFlag = MOSTest7thBit(cpu.registerValues.x - value);
}

@end
