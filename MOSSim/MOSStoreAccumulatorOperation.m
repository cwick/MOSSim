#import "MOSStoreAccumulatorOperation.h"
#import "MOSCPU.h"
#import "MOSUtils.h"
#import "MOSInstructionDecoder.h"

@implementation MOSStoreAccumulatorOperation

- (void)execute:(MOSCPU *)cpu {
    switch (self.instruction.addressingMode) {
        case MOSAddressingModeZeroPage:
            [cpu writeWord:cpu.registerValues.a toAddress:self.instruction.pageOffset];
            break;
        case MOSAddressingModeIndirectIndexed: {
            MOSWord addressLow = [cpu readWordFromAddress:self.instruction.pageOffset];
            MOSWord addressHigh = [cpu readWordFromAddress:self.instruction.pageOffset + (MOSWord)1];
            MOSAbsoluteAddress address = MOSAbsoluteAddressMake(addressLow, addressHigh);
            address += cpu.registerValues.y;

            [cpu writeWord:cpu.registerValues.a toAddress:address];
            break;
        }
    }
}

@end
