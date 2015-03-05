#import "MOSCompareOperation.h"
#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"
#import "MOSUtils.h"

@implementation MOSCompareOperation

- (instancetype)initWithInstruction:(MOSInstruction *)instruction {
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
    cpu.statusRegister.zeroFlag = (self.value == cpu.registerValues.x);
    cpu.statusRegister.carryFlag = (cpu.registerValues.x >= self.value);
    cpu.statusRegister.negativeFlag = MOSTest7thBit(cpu.registerValues.x - self.value);
}

@end
