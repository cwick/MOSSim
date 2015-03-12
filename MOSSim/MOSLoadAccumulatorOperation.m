#import "MOSLoadAccumulatorOperation.h"
#import "MOSCPU.h"
#import "MOSUtils.h"
#import "MOSInstructionDecoder.h"

@implementation MOSLoadAccumulatorOperation

- (void)execute:(MOSCPU *)cpu {
    switch (self.instruction.addressingMode) {
        case MOSAddressingModeImmediate:
            cpu.registerValues.a = self.instruction.immediateValue;
            break;
        case MOSAddressingModeZeroPage:
            cpu.registerValues.a = [cpu readWordFromAddress:self.instruction.pageOffset];
            break;
        case MOSAddressingModeIndirectIndexed: {
            MOSWord addressLow = [cpu readWordFromAddress:self.instruction.pageOffset];
            MOSWord addressHigh = [cpu readWordFromAddress:self.instruction.pageOffset + (MOSWord)1];
            MOSAbsoluteAddress address = MOSAbsoluteAddressMake(addressLow, addressHigh);
            address += cpu.registerValues.y;

            cpu.registerValues.a = [cpu readWordFromAddress:address];
            break;
        }
    }

    cpu.statusRegister.zeroFlag = (cpu.registerValues.a == 0);
    cpu.statusRegister.negativeFlag = MOSTest7thBit(cpu.registerValues.a);
}

@end
