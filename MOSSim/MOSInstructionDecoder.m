#import "MOSInstructionDecoder.h"
#import "MOSUtils.h"

@interface MOSInstructionDecoder ()

@property(nonatomic) id<MOSDataStream> dataStream;

@end

@implementation MOSInstruction

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
    MOSOPCode opcode = (MOSOPCode)[self.dataStream nextWord];
    MOSInstruction *instruction = [MOSInstruction new];
    
    [self decodeOPCode:opcode intoInstruction:instruction];
    [self decodeAddressesIntoInstruction:instruction];
    
    return instruction;
}

#define OPCODE(_opcode, _name, _addressingMode, _isAddressingModeIndexed) \
    case MOSOPCode##_opcode: \
        instruction.opcode = MOSOPCode##_opcode; \
        instruction.operationName = @#_name; \
        instruction.addressingMode = MOSAddressingMode##_addressingMode; \
        instruction.isAddressingModeIndexed = _isAddressingModeIndexed; \
        break

- (void)decodeOPCode:(MOSOPCode)opcode intoInstruction:(MOSInstruction *)instruction {
    switch (opcode) {
        // name, operation, addressingMode, isAddressingModeIndexed
        OPCODE(CLC, ClearCarryFlag, Implied, NO);
        OPCODE(SEC, SetCarryFlag, Implied, NO);
        OPCODE(CLD, ClearDecimalMode, Implied, NO);
        OPCODE(RTS, ReturnFromSubroutine, Implied, NO);
        OPCODE(JMP, Jump, Absolute, NO);
        OPCODE(BCC, BranchOnCarryClear, Relative, NO);
        OPCODE(BCS, BranchOnCarrySet, Relative, NO);
        OPCODE(BEQ, BranchOnResultZero, Relative, NO);
        OPCODE(BNE, BranchOnResultNotZero, Relative, NO);
            
        OPCODE(INCAbsolute, IncrementByOne, Absolute, NO);
        OPCODE(INCAbsoluteIndexed, IncrementByOne, Absolute, YES);
        OPCODE(INCZeroPage, IncrementByOne, ZeroPage, NO);
        OPCODE(INCZeroPageIndexed, IncrementByOne, ZeroPage, YES);
            
        OPCODE(ANDImmediate, AND, Immediate, NO);
        OPCODE(ANDZeroPage, AND, ZeroPage, NO);
        OPCODE(ANDZeroPageIndexed, AND, ZeroPage, YES);
        OPCODE(ANDAbsolute, AND, Absolute, NO);
            
        OPCODE(LDXImmediate, LoadRegister, Immediate, NO);
        OPCODE(INX, IncrementRegister, Implied, NO);
            
        OPCODE(CPXImmediate, Compare, Immediate, NO);
            
        OPCODE(JSR, JumpToSubroutine, Absolute, NO);
            
        default:
            [NSException raise:@"Unknown opcode" format:@"%ld", opcode];
            break;
    }
}

- (void)decodeAddressesIntoInstruction:(MOSInstruction *)instruction {
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
        case MOSAddressingModeImmediate:
            instruction.immediateValue = [self decodeImmediateValue];
            break;
        default:
            break;
    }
}
- (MOSImmediateValue)decodeImmediateValue {
    return (MOSImmediateValue)[self.dataStream nextWord];
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
