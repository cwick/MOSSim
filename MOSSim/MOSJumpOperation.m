#import "MOSJumpOperation.h"
#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"

@implementation MOSJumpOperation

- (instancetype)initWithAbsoluteAddress:(MOSAbsoluteAddress)address {
    self = [super init];
    if (self) {
        _absoluteAddress = address;
    }
    return self;
}

- (instancetype)initWithInstruction:(MOSInstruction *)instruction {
    self = [super initWithInstruction:instruction];
    if (self) {
        _absoluteAddress = instruction.absoluteAddress;
    }
    
    return self;
}

- (void)execute:(MOSCPU *)cpu {
    cpu.programCounter = self.absoluteAddress;
}

@end
