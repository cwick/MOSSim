#import "MOSReturnFromSubroutineOperation.h"
#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"
#import "MOSUtils.h"

@implementation MOSReturnFromSubroutineOperation

- (instancetype)initWithInstruction:(MOSInstruction* )instruction {
    return [super init];
}

- (void)execute:(MOSCPU *)cpu {
    MOSWord returnAddressLow = [cpu popStack];
    MOSWord returnAddressHigh = [cpu popStack];
    MOSAbsoluteAddress returnAddress = MOSAbsoluteAddressMake(returnAddressHigh, returnAddressLow);
    
    cpu.programCounter = returnAddress + 1;
}

@end
