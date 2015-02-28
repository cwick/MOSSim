#import "MOSInstruction.h"
#import "MOSInstructionDecoder+Private.h"

@implementation MOSInstruction

- (instancetype)initWithOPCode:(MOSOPCode)opcode decoder:(MOSInstructionDecoder *)decoder{
    self = [super init];
    if (self) {
        _opcode = opcode;
        _addressingMode = MOSAddressingModeImplied;
        
        [self decodeOPCode];
        [self decodeAddresses:decoder];
    }
    
    return self;
}

#define OPCODE(name, operation, addressingMode, isAddressingModeIndexed) \
    case MOSOPCode##name: \
        _operation = MOSOperation##operation; \
        _addressingMode = MOSAddressingMode##addressingMode; \
        _isAddressingModeIndexed = isAddressingModeIndexed; \
        break

- (void)decodeOPCode {
    switch (self.opcode) {
        // name, operation, addressingMode, isAddressingModeIndexed
        OPCODE(CLC, ClearCarryFlag, Implied, NO);
        OPCODE(SEC, SetCarryFlag, Implied, NO);
        OPCODE(CLD, ClearDecimalMode, Implied, NO);
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
            
        OPCODE(CPXImmediate, Compare, Immediate, NO);
            
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
        case MOSAddressingModeImmediate:
            _immediateValue = [decoder decodeImmediateValue];
            break;
        default:
            break;
    }
}

@end

