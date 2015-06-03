#import "MOSClearDecimalModeOperation.h"
#import "MOSCPU.h"

@implementation MOSClearDecimalModeOperation

- (void)execute:(MOSCPU *)cpu {
    cpu.statusRegister.decimalMode = NO;
}

@end