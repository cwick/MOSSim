#import "MOSIncrementMemoryOperation.h"
#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"
#import "MOSUtils.h"

@implementation MOSIncrementMemoryOperation

- (void)execute:(MOSCPU *)cpu {
    MOSAbsoluteAddress address = [self.instruction resolveAddress:cpu];
    MOSWord value = [cpu readWordFromAddress:address];
    MOSWord incrementedValue = (MOSWord) (value + 1);
    [cpu writeWord:incrementedValue toAddress:address];

    cpu.statusRegister.zeroFlag = (incrementedValue == 0);
    cpu.statusRegister.negativeFlag = MOSTestHighBit(incrementedValue);
}

@end
