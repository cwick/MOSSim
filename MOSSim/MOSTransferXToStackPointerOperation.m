#import "MOSTransferXToStackPointerOperation.h"
#import "MOSCPU.h"

@implementation MOSTransferXToStackPointerOperation

- (void)execute:(MOSCPU *)cpu {
    cpu.stackPointer = cpu.registerValues.x;
}

@end
