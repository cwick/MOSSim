#import "MOSCompareOperation.h"
#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"
#import "MOSUtils.h"

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
    cpu.statusRegister.carryFlag = (cpu.registerValues.x >= self.value);
    cpu.statusRegister.negativeFlag = MOSTest7thBit(cpu.registerValues.x - self.value);
}

@end
