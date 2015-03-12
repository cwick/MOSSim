#import "MOSForceBreakOperation.h"
#import "MOSCPU.h"

@implementation MOSForceBreakOperation

- (void)execute:(MOSCPU *)cpu {
    cpu.isHalted = true;
}

@end
