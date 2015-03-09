#import "MOSDecrementRegisterOperation.h"
#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"
#import "MOSUtils.h"

@implementation MOSDecrementRegisterOperation

- (instancetype)initWithInstruction:(MOSInstruction* )instruction {
    return [super init];
}

- (void)execute:(MOSCPU *)cpu {
    cpu.registerValues.y -= 1;
    cpu.statusRegister.zeroFlag = (cpu.registerValues.y == 0);
    cpu.statusRegister.negativeFlag = MOSTest7thBit(cpu.registerValues.y);
}

@end
