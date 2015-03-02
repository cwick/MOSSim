#import "MOSLoadRegisterOperation.h"
#import "MOSCPU.h"
#import "MOSTypes.h"
#import "MOSInstructionDecoder.h"

@implementation MOSLoadRegisterOperation

- (instancetype)initWithInstruction:(MOSInstruction* )instruction {
    self = [super init];
    if (self) {
        _value = instruction.immediateValue;
    }
    return self;
}

- (instancetype)initWithImmediateValue:(MOSImmediateValue)value {
    MOSInstruction *i = [MOSInstruction new];
    i.immediateValue = value;
    return [self initWithInstruction:i];
}

- (void)execute:(MOSCPU *)cpu {
    cpu.registerValues.x = self.value;
}

@end
