#import "MOSJumpOperation.h"
#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"

@implementation MOSJumpOperation

- (instancetype)initWithInstruction:(MOSInstruction *)instruction {
    return [self initWithAbsoluteAddress:instruction.absoluteAddress];
}

- (instancetype)initWithAbsoluteAddress:(MOSAbsoluteAddress)address {
    self = [super init];
    if (self) {
        _absoluteAddress = address;
    }
    return self;
}

- (void)execute:(MOSCPU *)cpu {
    cpu.programCounter = self.absoluteAddress;
}

@end
