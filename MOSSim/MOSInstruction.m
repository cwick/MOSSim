#import "MOSInstruction.h"
#import "MOSUtils.h"
#import "MOSCPU.h"

@implementation MOSInstruction

- (instancetype)initWithOperand:(MOSOperand)operand addressingMode:(MOSAddressingMode)mode {
    self = [super init];
    if (self) {
        switch(mode) {
            case MOSAddressingModeRelative:
                _relativeAddress = (MOSRelativeAddress)operand;
                break;
            case MOSAddressingModeAbsolute:
            case MOSAddressingModeAbsoluteIndexedX:
                _absoluteAddress = operand;
                break;
            case MOSAddressingModeImmediate:
                _immediateValue = (MOSImmediateValue)operand;
                break;
            case MOSAddressingModeIndirectIndexed:
            case MOSAddressingModeZeroPage:
                _pageOffset = (MOSPageOffset)operand;
                break;
            default:
                [NSException raise:@"Invalid addressing mode" format:@"%lld", (long long int) mode];
        }

        _addressingMode = mode;
    }

    return self;
}

- (MOSAbsoluteAddress)resolveAddress:(MOSCPU *)cpu {
    switch (self.addressingMode) {
        case MOSAddressingModeZeroPage:
            return self.pageOffset;
        case MOSAddressingModeIndirectIndexed: {
            MOSWord addressLow = [cpu readWordFromAddress:self.pageOffset];
            MOSWord addressHigh = [cpu readWordFromAddress:self.pageOffset + (MOSWord)1];
            MOSAbsoluteAddress address = MOSAbsoluteAddressMake(addressLow, addressHigh);
            address += cpu.registerValues.y;
            return address;
            case MOSAddressingModeAbsoluteIndexedX:
                return self.absoluteAddress + cpu.registerValues.x;
            case MOSAddressingModeAbsolute:
                return self.absoluteAddress;
            default:
                [NSException raise:@"Invalid addressing mode" format:@"%lld", (long long int) self.addressingMode];
        }
    }

    return 0;
}

@end

