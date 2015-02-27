#import "MOSSetCarryFlagOperation.h"
#import "MOSCPU.h"
#import "MOSStatusRegister.h"

@implementation MOSSetCarryFlagOperation

- (void)execute:(MOSCPU *)cpu {
    cpu.statusRegister.carryFlag = YES;
}

@end
