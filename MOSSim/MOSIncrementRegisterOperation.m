#import "MOSIncrementRegisterOperation.h"
#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"

@implementation MOSIncrementRegisterOperation

- (instancetype)initWithInstruction:(MOSInstruction* )instruction {
    return [super init];
}

- (void)execute:(MOSCPU *)cpu {
    cpu.registerValues.x += 1;
    cpu.statusRegister.zeroFlag = (cpu.registerValues.x == 0);
    cpu.statusRegister.negativeFlag = [MOSCPU is7thBitSet:cpu.registerValues.x];
}

@end
