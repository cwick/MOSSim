#import "MOSCompareOperation.h"
#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"

@implementation MOSCompareOperation

- (instancetype)initWithInstruction:(MOSInstruction *)instruction {
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
    cpu.statusRegister.zeroFlag = (self.value == cpu.registerValues.x);
}

@end
