#import "MOSLoadAccumulatorOperation.h"
#import "MOSCPU.h"
#import "MOSUtils.h"

@interface MOSLoadAccumulatorOperation()

@property(nonatomic) MOSWord operand;
@property(nonatomic) MOSAddressingMode addressingMode;

@end

@implementation MOSLoadAccumulatorOperation

- (instancetype)initWithImmediateValue:(MOSImmediateValue)value {
    self = [super init];
    if (self) {
        _operand = value;
        _addressingMode = MOSAddressingModeImmediate;
    }

    return self;
}

- (instancetype)initWithPageOffset:(MOSPageOffset)offset {
    self = [super init];
    if (self) {
        _operand = offset;
        _addressingMode = MOSAddressingModeZeroPage;
    }

    return self;
}

//- (instancetype)initWithInstruction:(MOSInstruction *)instruction {
//    return [super init];
//}
//
- (void)execute:(MOSCPU *)cpu {
    switch (self.addressingMode) {
        case MOSAddressingModeImmediate:
            cpu.registerValues.a = self.operand;
            break;
        case MOSAddressingModeZeroPage:
            cpu.registerValues.a = [cpu readWordFromAddress:self.operand];
            break;
    }

    cpu.statusRegister.zeroFlag = (cpu.registerValues.a == 0);
    cpu.statusRegister.negativeFlag = MOSTest7thBit(cpu.registerValues.a);
}

@end
