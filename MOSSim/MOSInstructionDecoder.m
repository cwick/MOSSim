#import "MOSInstructionDecoder.h"

static const int BITS_PER_BYTE = 8;

MOSAbsoluteAddress MOSAbsoluteAddressMake(MOSWord high, MOSWord low) {
    return (high << BITS_PER_BYTE) | low;
}

@implementation MOSInstruction

- (instancetype)init {
    self = [super init];
    if (self) {
        _addressingMode = MOSAddressingModeImplied;
    }
    
    return self;
}

@end

@interface MOSInstructionDecoder ()

@property(nonatomic) id<MOSDataStream> dataStream;

@end

@implementation MOSInstructionDecoder

- (instancetype)initWithDataStream:(id<MOSDataStream>)stream {
    self = [super init];
    if (self) {
        _dataStream = stream;
    }
    
    return self;
}

- (MOSInstruction *)decodeNextInstruction {
    MOSInstruction *instruction = [MOSInstruction new];
    instruction.opcode = (MOSOPCode)[self.dataStream nextWord];
    
    switch (instruction.opcode) {
        case MOSOPCodeCLC:
            instruction.operation = MOSOperationClearCarryFlag;
            break;
        case MOSOPCodeSEC:
            instruction.operation = MOSOperationSetCarryFlag;
            break;
        case MOSOPCodeCLD:
            instruction.operation = MOSOperationClearDecimalMode;
            break;
        case MOSOPCodeJMP:
            instruction.operation = MOSOperationJump;
            instruction.addressingMode = MOSAddressingModeAbsolute;
            break;
        case MOSOPCodeBCC:
            instruction.operation = MOSOperationBranchOnCarryClear;
            instruction.addressingMode = MOSAddressingModeRelative;
            break;
        case MOSOPCodeBCS:
            instruction.operation = MOSOperationBranchOnCarrySet;
            instruction.addressingMode = MOSAddressingModeRelative;
            break;
        case MOSOPCodeBEQ:
            instruction.operation = MOSOperationBranchOnResultZero;
            instruction.addressingMode = MOSAddressingModeRelative;
            break;
        case MOSOPCodeBNE:
            instruction.operation = MOSOperationBranchOnResultNotZero;
            instruction.addressingMode = MOSAddressingModeRelative;
            break;
        case MOSOPCodeINCAbsolute:
            instruction.operation = MOSOperationIncrementByOne;
            instruction.addressingMode = MOSAddressingModeAbsolute;
            break;
        case MOSOPCodeINCZeroPage:
            instruction.operation = MOSOperationIncrementByOne;
            instruction.addressingMode = MOSAddressingModeZeroPage;
            break;
        case MOSOPCodeINCZeroPageIndexed:
            instruction.isAddressingModeIndexed = YES;
            instruction.operation = MOSOperationIncrementByOne;
            instruction.addressingMode = MOSAddressingModeZeroPage;
            break;
        default:
            break;
    }
    
    switch (instruction.addressingMode) {
        case MOSAddressingModeRelative:
            instruction.relativeAddress = [self decodeRelativeAddress];
            break;
        case MOSAddressingModeAbsolute:
            instruction.absoluteAddress = [self decodeAbsoluteAddress];
            break;
        case MOSAddressingModeZeroPage:
            instruction.pageOffset = [self decodePageOffset];
            break;
        default:
            break;
    }
    
    return instruction;
}

- (MOSPageOffset)decodePageOffset {
    return (MOSPageOffset)[self.dataStream nextWord];
}

- (MOSRelativeAddress)decodeRelativeAddress {
    return (MOSRelativeAddress)[self.dataStream nextWord];
}

- (MOSAbsoluteAddress)decodeAbsoluteAddress {
    MOSWord addressLow = [self.dataStream nextWord];
    MOSWord addressHigh = [self.dataStream nextWord];
    
    return MOSAbsoluteAddressMake(addressHigh, addressLow);
}

@end
