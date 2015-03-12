#import "MOSStoreAccumulatorOperation.h"
#import "MOSCPU.h"
#import "MOSUtils.h"
#import "MOSInstructionDecoder.h"

@implementation MOSStoreAccumulatorOperation

- (void)execute:(MOSCPU *)cpu {
    MOSOperand operand = [self.instruction resolveOperand:cpu];
    [cpu writeWord:cpu.registerValues.a toAddress:(MOSAbsoluteAddress)operand];
}

@end
