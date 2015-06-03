#import "MOSSetInterruptDisableOperation.h"
#import "MOSCPU.h"


@implementation MOSSetInterruptDisableOperation

- (void)execute:(MOSCPU *)cpu {
    cpu.statusRegister.interruptDisable = YES;
}

@end