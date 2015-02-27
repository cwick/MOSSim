#import "MOSJumpOperation.h"
#import "MOSCPU.h"

@implementation MOSJumpOperation

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
