#import "MOSInstructionDecoder.h"
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
        default:
            [NSException raise:@"Invalid addressing mode" format:@"%lld", (long long int) self.addressingMode];
        }
    }

    return 0;
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
        OPCODE(SEI, SetInterruptDisable, Implied);
        OPCODE(RTS, ReturnFromSubroutine, Implied);
        OPCODE(BRK, ForceBreak, Implied);
        OPCODE(JMP, Jump, Absolute);
        OPCODE(BCC, BranchOnCarryClear, Relative);
        OPCODE(BCS, BranchOnCarrySet, Relative);
        OPCODE(BEQ, BranchOnResultZero, Relative);
        OPCODE(BNE, BranchOnResultNotZero, Relative);
        OPCODE(TXS, TransferXToStackPointer, Implied);
        OPCODE(TAY, TransferAccumulatorToY, Implied);

        OPCODE(INCAbsolute, IncrementMemoryByOne, Absolute);
        OPCODE(INCAbsoluteIndexed, IncrementMemoryByOne, AbsoluteIndexedX);
        OPCODE(INCZeroPage, IncrementMemoryByOne, ZeroPage);
        OPCODE(INCZeroPageIndexed, IncrementMemoryByOne, ZeroPageX);
            
        OPCODE(ANDImmediate, AND, Immediate);
        OPCODE(ANDZeroPage, AND, ZeroPage);
        OPCODE(ANDZeroPageIndexed, AND, ZeroPageX);
        OPCODE(ANDAbsolute, AND, Absolute);
            
        OPCODE(LDXImmediate, LoadRegisterX, Immediate);
        OPCODE(LDYImmediate, LoadRegisterY, Immediate);
        OPCODE(INX, IncrementRegisterX, Implied);
        OPCODE(INY, IncrementRegisterY, Implied);
        OPCODE(DEY, DecrementRegister, Implied);

        OPCODE(STXZeroPage, StoreRegisterX, ZeroPage);

        OPCODE(CPXImmediate, CompareX, Immediate);
        OPCODE(CPYImmediate, CompareY, Immediate);

        OPCODE(JSR, JumpToSubroutine, Absolute);

        OPCODE(LDAImmediate, LoadAccumulator, Immediate);
        OPCODE(LDAZeroPage, LoadAccumulator, ZeroPage);
        OPCODE(LDAIndirectIndexed, LoadAccumulator, IndirectIndexed);

        OPCODE(STAZeroPage, StoreAccumulator, ZeroPage);
        OPCODE(STAIndirectIndexed, StoreAccumulator, IndirectIndexed);
        OPCODE(STAAbsoluteIndexedX, StoreAccumulator, AbsoluteIndexedX);

        default:
            [NSException raise:@"Unknown opcode" format:@"0x%x", opcode];
    }
}

- (void)decodeAddressesIntoInstruction:(MOSInstruction *)instruction {
    switch (instruction.addressingMode) {
        case MOSAddressingModeRelative:
            instruction.relativeAddress = [self decodeRelativeAddress];
            break;
        case MOSAddressingModeAbsolute:
        case MOSAddressingModeAbsoluteIndexedX:
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
