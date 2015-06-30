#import "MOSJumpToSubroutineOperation.h"
#import "MOSCPU.h"
#import "MOSUtils.h"
#import "MOSInstruction.h"

@implementation MOSJumpToSubroutineOperation

- (void)execute:(MOSCPU *)cpu {
    MOSAbsoluteAddress returnAddress = cpu.programCounter - (MOSAbsoluteAddress)1;
    
    [cpu pushStack:MOSAddressHigh(returnAddress)];
    [cpu pushStack:MOSAddressLow(returnAddress)];
    
    cpu.programCounter = self.instruction.absoluteAddress;
}

@end
