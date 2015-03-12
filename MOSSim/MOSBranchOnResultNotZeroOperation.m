#import "MOSBranchOnResultNotZeroOperation.h"
#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"

@implementation MOSBranchOnResultNotZeroOperation

- (void)execute:(MOSCPU *)cpu {
    if (!cpu.statusRegister.zeroFlag) {
        cpu.programCounter += self.instruction.relativeAddress;
    }
}

@end
