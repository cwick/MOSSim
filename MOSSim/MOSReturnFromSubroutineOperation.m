#import "MOSReturnFromSubroutineOperation.h"
#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"
#import "MOSUtils.h"

@implementation MOSReturnFromSubroutineOperation

- (void)execute:(MOSCPU *)cpu {
    MOSWord returnAddressLow = [cpu popStack];
    MOSWord returnAddressHigh = [cpu popStack];
    MOSAbsoluteAddress returnAddress = MOSAbsoluteAddressMake(returnAddressLow, returnAddressHigh);
    
    cpu.programCounter = returnAddress + (MOSWord)1;
}

@end
