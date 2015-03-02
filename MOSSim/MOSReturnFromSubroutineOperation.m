#import "MOSReturnFromSubroutineOperation.h"
#import "MOSCPU.h"

@implementation MOSReturnFromSubroutineOperation

- (void)execute:(MOSCPU *)cpu {
    cpu.isHalted = YES;
}

@end
