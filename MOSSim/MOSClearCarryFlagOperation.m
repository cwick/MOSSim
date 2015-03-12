#import "MOSClearCarryFlagOperation.h"
#import "MOSCPU.h"
#import "MOSStatusRegister.h"

@implementation MOSClearCarryFlagOperation

- (void)execute:(MOSCPU *)cpu {
    cpu.statusRegister.carryFlag = NO;
}

@end
