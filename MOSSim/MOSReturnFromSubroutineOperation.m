#import "MOSReturnFromSubroutineOperation.h"
#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"

@implementation MOSReturnFromSubroutineOperation

- (instancetype)initWithInstruction:(MOSInstruction* )instruction {
    return [super init];
}

- (void)execute:(MOSCPU *)cpu {
    cpu.isHalted = YES;
}

@end
