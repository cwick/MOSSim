#import "MOSClearCarryFlagOperation.h"
#import "MOSCPU.h"
#import "MOSStatusRegister.h"

@implementation MOSClearCarryFlagOperation

- (instancetype)initWithInstruction:(MOSInstruction *)instruction {
    self = [super init];
    return self;
}

- (void)execute:(MOSCPU *)cpu {
    cpu.statusRegister.carryFlag = NO;
}

@end
