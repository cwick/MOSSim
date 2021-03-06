#import "MOSIncrementMemoryOperation.h"
#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"
#import "MOSUtils.h"
#import "MOSInstruction.h"

@implementation MOSIncrementMemoryOperation

- (void)execute:(MOSCPU *)cpu {
    MOSAbsoluteAddress address = [self.instruction resolveAddress:cpu];
    MOSWord value = [cpu readWordFromAddress:address];
    MOSWord incrementedValue = (MOSWord) (value + 1);

    [cpu writeWord:incrementedValue toAddress:address];
    [cpu.statusRegister setZeroAndNegativeFlagsFromValue:incrementedValue];
}

@end
