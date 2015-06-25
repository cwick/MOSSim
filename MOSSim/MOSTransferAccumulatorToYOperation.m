#import "MOSTransferAccumulatorToYOperation.h"
#import "MOSCPU.h"

@implementation MOSTransferAccumulatorToYOperation

- (void)execute:(MOSCPU *)cpu {
    cpu.registerValues.y = cpu.registerValues.a;
}

@end
