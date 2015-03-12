#import "MOSLoadAccumulatorOperation.h"
#import "MOSCPU.h"
#import "MOSUtils.h"
#import "MOSInstructionDecoder.h"

@implementation MOSLoadAccumulatorOperation

- (void)execute:(MOSCPU *)cpu {
    MOSOperand operand = [self.instruction resolveOperand:cpu];
    if (self.instruction.addressingMode == MOSAddressingModeImmediate) {
        cpu.registerValues.a = (MOSRegisterValue)operand;
    } else {
        cpu.registerValues.a = [cpu readWordFromAddress:(MOSAbsoluteAddress) operand];
    }

    cpu.statusRegister.zeroFlag = (cpu.registerValues.a == 0);
    cpu.statusRegister.negativeFlag = MOSTest7thBit(cpu.registerValues.a);
}

@end
