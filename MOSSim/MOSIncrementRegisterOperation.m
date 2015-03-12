#import "MOSIncrementRegisterOperation.h"
#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"
#import "MOSUtils.h"

@implementation MOSIncrementRegisterOperation

- (void)execute:(MOSCPU *)cpu {
    cpu.registerValues.x += 1;
    cpu.statusRegister.zeroFlag = (cpu.registerValues.x == 0);
    cpu.statusRegister.negativeFlag = MOSTest7thBit(cpu.registerValues.x);
}

@end
