#import "MOSClearCarryFlagOperation.h"
#import "MOSCPU.h"
#import "MOSStatusRegister.h"

@implementation MOSClearCarryFlagOperation

- (instancetype)initWithInstruction:(MOSInstruction *)instruction {
    return [super init];
}

- (void)execute:(MOSCPU *)cpu {
    cpu.statusRegister.carryFlag = NO;
}

@end
