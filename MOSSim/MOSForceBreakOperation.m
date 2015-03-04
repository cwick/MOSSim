#import "MOSForceBreakOperation.h"
#import "MOSCPU.h"

@implementation MOSForceBreakOperation

- (instancetype)initWithInstruction:(MOSInstruction *)instruction {
    return [super init];
}

- (void)execute:(MOSCPU *)cpu {
    cpu.isHalted = true;
}

@end
