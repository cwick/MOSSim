#import "MOSLoadRegisterOperation.h"
#import "MOSCPU.h"
#import "MOSTypes.h"
#import "MOSInstructionDecoder.h"

@implementation MOSLoadRegisterOperation

- (instancetype)initWithInstruction:(MOSInstruction* )instruction {
    return [self initWithImmediateValue:instruction.immediateValue];
}

- (instancetype)initWithImmediateValue:(MOSImmediateValue)value {
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

- (void)execute:(MOSCPU *)cpu {
    cpu.registerValues.x = self.value;
}

@end
