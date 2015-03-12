#import "MOSLoadAccumulatorOperation.h"
#import "MOSCPU.h"
#import "MOSUtils.h"
#import "MOSInstructionDecoder.h"

@implementation MOSLoadAccumulatorOperation

- (void)execute:(MOSCPU *)cpu {
    MOSRegisterValue value;
    if (self.instruction.addressingMode == MOSAddressingModeImmediate) {
        value = self.instruction.immediateValue;
    } else {
        MOSAbsoluteAddress address = [self.instruction resolveAddress:cpu];
        value = [cpu readWordFromAddress:address];
    }

    cpu.registerValues.a = value;
    cpu.statusRegister.zeroFlag = (cpu.registerValues.a == 0);
    cpu.statusRegister.negativeFlag = MOSTest7thBit(cpu.registerValues.a);
}

@end
