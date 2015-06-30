#import "MOSJumpOperation.h"
#import "MOSCPU.h"
#import "MOSInstruction.h"

@implementation MOSJumpOperation

- (void)execute:(MOSCPU *)cpu {
    cpu.programCounter = self.instruction.absoluteAddress;
}

@end
