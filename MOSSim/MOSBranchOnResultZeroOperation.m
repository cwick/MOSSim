#import "MOSBranchOnResultZeroOperation.h"
#import "MOSCPU.h"
#import "MOSInstruction.h"

@implementation MOSBranchOnResultZeroOperation

- (void)execute:(MOSCPU *)cpu {
    if (cpu.statusRegister.zeroFlag) {
        cpu.programCounter += self.instruction.relativeAddress;
    }
}

@end
