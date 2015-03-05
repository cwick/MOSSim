#import "MOSTransferXToStackPointerOperation.h"
#import "MOSCPU.h"

@implementation MOSTransferXToStackPointerOperation

- (instancetype)initWithInstruction:(MOSInstruction *)instruction {
    return [super init];
}

- (void)execute:(MOSCPU *)cpu {
    cpu.stackPointer = cpu.registerValues.x;
}

@end
