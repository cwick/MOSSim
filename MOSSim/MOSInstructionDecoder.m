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

#define OPCODE(_opcode, _name, _addressingMode) \
    case MOSOPCode##_opcode: \
        instruction.opcode = MOSOPCode##_opcode; \
        instruction.operationName = @#_name; \
        instruction.addressingMode = MOSAddressingMode##_addressingMode; \
        break

- (void)decodeOPCode:(MOSOPCode)opcode intoInstruction:(MOSInstruction *)instruction {
    switch (opcode) {
        // name, operation, addressingMode
        OPCODE(CLC, ClearCarryFlag, Implied);
        OPCODE(SEC, SetCarryFlag, Implied);
        OPCODE(CLD, ClearDecimalMode, Implied);
        OPCODE(RTS, ReturnFromSubroutine, Implied);
        OPCODE(BRK, ForceBreak, Implied);
        OPCODE(JMP, Jump, Absolute);
        OPCODE(BCC, BranchOnCarryClear, Relative);
        OPCODE(BCS, BranchOnCarrySet, Relative);
        OPCODE(BEQ, BranchOnResultZero, Relative);
        OPCODE(BNE, BranchOnResultNotZero, Relative);
        OPCODE(TXS, TransferXToStackPointer, Implied);
            
        OPCODE(INCAbsolute, IncrementByOne, Absolute);
        OPCODE(INCAbsoluteIndexed, IncrementByOne, AbsoluteX);
        OPCODE(INCZeroPage, IncrementByOne, ZeroPage);
        OPCODE(INCZeroPageIndexed, IncrementByOne, ZeroPageX);
            
        OPCODE(ANDImmediate, AND, Immediate);
        OPCODE(ANDZeroPage, AND, ZeroPage);
        OPCODE(ANDZeroPageIndexed, AND, ZeroPageX);
        OPCODE(ANDAbsolute, AND, Absolute);
            
        OPCODE(LDXImmediate, LoadRegisterX, Immediate);
        OPCODE(LDYImmediate, LoadRegisterY, Immediate);
        OPCODE(INX, IncrementRegister, Implied);
        OPCODE(DEY, DecrementRegister, Implied);

        OPCODE(CPXImmediate, Compare, Immediate);
            
        OPCODE(JSR, JumpToSubroutine, Absolute);

        OPCODE(LDAImmediate, LoadAccumulator, Immediate);
        OPCODE(LDAZeroPage, LoadAccumulator, ZeroPage);
        OPCODE(LDAIndirectIndexed, LoadAccumulator, IndirectIndexed);

        default:
            [NSException raise:@"Unknown opcode" format:@"%ld", opcode];
    }
}

- (void)decodeAddressesIntoInstruction:(MOSInstruction *)instruction {
    switch (instruction.addressingMode) {
        case MOSAddressingModeRelative:
            instruction.relativeAddress = [self decodeRelativeAddress];
            break;
        case MOSAddressingModeAbsolute:
        case MOSAddressingModeAbsoluteX:
            instruction.absoluteAddress = [self decodeAbsoluteAddress];
            break;
        case MOSAddressingModeZeroPage:
        case MOSAddressingModeZeroPageX:
        case MOSAddressingModeIndirectIndexed:
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
    
    return MOSAbsoluteAddressMake(addressLow, addressHigh);
}

@end
