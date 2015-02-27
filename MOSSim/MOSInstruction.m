#import "MOSInstruction.h"
#import "MOSInstructionDecoder+Private.h"

@implementation MOSInstruction

- (instancetype)initWithOPCode:(MOSOPCode)opcode decoder:(MOSInstructionDecoder *)decoder{
    self = [super init];
    if (self) {
        _opcode = opcode;
        _addressingMode = MOSAddressingModeImplied;
        
        [self setupProperties];
        [self decodeAddresses:decoder];
    }
    
    return self;
}

- (void)setupProperties {
    switch (self.opcode) {
        case MOSOPCodeCLC:
            _operation = MOSOperationClearCarryFlag;
            break;
        case MOSOPCodeSEC:
            _operation = MOSOperationSetCarryFlag;
            break;
        case MOSOPCodeCLD:
            _operation = MOSOperationClearDecimalMode;
            break;
        case MOSOPCodeJMP:
            _operation = MOSOperationJump;
            _addressingMode = MOSAddressingModeAbsolute;
            break;
        case MOSOPCodeBCC:
            _operation = MOSOperationBranchOnCarryClear;
            _addressingMode = MOSAddressingModeRelative;
            break;
        case MOSOPCodeBCS:
            _operation = MOSOperationBranchOnCarrySet;
            _addressingMode = MOSAddressingModeRelative;
            break;
        case MOSOPCodeBEQ:
            _operation = MOSOperationBranchOnResultZero;
            _addressingMode = MOSAddressingModeRelative;
            break;
        case MOSOPCodeBNE:
            _operation = MOSOperationBranchOnResultNotZero;
            _addressingMode = MOSAddressingModeRelative;
            break;
        case MOSOPCodeINCAbsoluteIndexed:
            _isAddressingModeIndexed = YES;
        case MOSOPCodeINCAbsolute:
            _operation = MOSOperationIncrementByOne;
            _addressingMode = MOSAddressingModeAbsolute;
            break;
        case MOSOPCodeINCZeroPageIndexed:
            _isAddressingModeIndexed = YES;
        case MOSOPCodeINCZeroPage:
            _operation = MOSOperationIncrementByOne;
            _addressingMode = MOSAddressingModeZeroPage;
            break;
        default:
            break;
    }
    
}

- (void)decodeAddresses:(MOSInstructionDecoder *)decoder {
    switch (self.addressingMode) {
        case MOSAddressingModeRelative:
            _relativeAddress = [decoder decodeRelativeAddress];
            break;
        case MOSAddressingModeAbsolute:
            _absoluteAddress = [decoder decodeAbsoluteAddress];
            break;
        case MOSAddressingModeZeroPage:
            _pageOffset = [decoder decodePageOffset];
            break;
        default:
            break;
    }
}

@end

