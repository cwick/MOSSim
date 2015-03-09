#import "MOSLoadAccumulatorOperation.h"
#import "MOSCPU.h"
#import "MOSUtils.h"

@interface MOSLoadAccumulatorOperation()

@property(nonatomic) MOSWord operand;
@property(nonatomic) MOSAddressingMode addressingMode;

@end

@implementation MOSLoadAccumulatorOperation

- (instancetype)initWithOperand:(MOSWord)operand addressingMode:(MOSAddressingMode)mode {
    self = [super init];
    if (self) {
        _operand = operand;
        _addressingMode = mode;
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
        case MOSAddressingModeIndirectIndexed: {
            MOSWord addressLow = [cpu readWordFromAddress:self.operand];
            MOSWord addressHigh = [cpu readWordFromAddress:self.operand + 1];
            MOSAbsoluteAddress address = MOSAbsoluteAddressMake(addressLow, addressHigh);
            address += cpu.registerValues.y;

            cpu.registerValues.a = [cpu readWordFromAddress:address];
            break;
        }
    }

    cpu.statusRegister.zeroFlag = (cpu.registerValues.a == 0);
    cpu.statusRegister.negativeFlag = MOSTest7thBit(cpu.registerValues.a);
}

@end
