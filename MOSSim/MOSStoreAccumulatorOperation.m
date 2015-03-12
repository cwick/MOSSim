#import "MOSStoreAccumulatorOperation.h"
#import "MOSCPU.h"
#import "MOSUtils.h"

@interface MOSStoreAccumulatorOperation()

@property(nonatomic) MOSWord operand;
@property(nonatomic) MOSAddressingMode addressingMode;

@end

@implementation MOSStoreAccumulatorOperation

- (instancetype)initWithOperand:(MOSWord)operand addressingMode:(MOSAddressingMode)mode {
    self = [super init];
    if (self) {
        _operand = operand;
        _addressingMode = mode;
    }

    return self;
}

- (void)execute:(MOSCPU *)cpu {
    switch (self.addressingMode) {
        case MOSAddressingModeZeroPage:
            [cpu writeWord:cpu.registerValues.a toAddress:self.operand];
            break;
        case MOSAddressingModeIndirectIndexed: {
            MOSWord addressLow = [cpu readWordFromAddress:self.operand];
            MOSWord addressHigh = [cpu readWordFromAddress:self.operand + 1];
            MOSAbsoluteAddress address = MOSAbsoluteAddressMake(addressLow, addressHigh);
            address += cpu.registerValues.y;

            [cpu writeWord:cpu.registerValues.a toAddress:address];
            break;
        }
    }
}

@end
