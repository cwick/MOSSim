#import "MOSInstruction.h"
#import <XCTest/XCTest.h>

#import "MOSInstructionDecoder.h"
#import "MOSFakeDataStream.h"

@interface MOSInstructionDecoderTests : XCTestCase

@property (nonatomic) MOSInstructionDecoder *decoder;
@property (nonatomic) MOSFakeDataStream *dataStream;

@end

@implementation MOSInstructionDecoderTests

- (void)setUp {
    self.dataStream = [MOSFakeDataStream new];
    self.decoder = [[MOSInstructionDecoder alloc] initWithDataStream:self.dataStream];
}

- (void)testUnaryOperators {
    //                        opcode   opcode name           operation
    NSDictionary *expected = @{@0x18: @[@(MOSOPCodeCLC), @"ClearCarryFlag"],
                               @0x38: @[@(MOSOPCodeSEC), @"SetCarryFlag"],
                               @0xD8: @[@(MOSOPCodeCLD), @"ClearDecimalMode"],
                               @0x78: @[@(MOSOPCodeSEI), @"SetInterruptDisable"],
                               @0xE8: @[@(MOSOPCodeINX), @"IncrementRegisterX"],
                               @0xC8: @[@(MOSOPCodeINY), @"IncrementRegisterY"],
                               @0xE8: @[@(MOSOPCodeDEY), @"DecrementRegister"],
                               @0x60: @[@(MOSOPCodeRTS), @"ReturnFromSubroutine"],
                               @0x00: @[@(MOSOPCodeBRK), @"ForceBreak"],
                               @0x9A: @[@(MOSOPCodeTXS), @"TransferXToStackPointer"],
                               @0xA8: @[@(MOSOPCodeTAY), @"TransferAccumulatorToY"] };

    for (NSNumber *opcode in expected.allKeys) {
        self.dataStream.data = @[@(opcode.unsignedCharValue)];
        MOSInstruction *instruction = [self.decoder decodeNextInstruction];
        XCTAssertEqual(@(instruction.opcode), expected[opcode][0],
                       @"failed to decode opcode %@", opcode);
        XCTAssertEqual(instruction.operationName, expected[opcode][1]);
        XCTAssertEqual(instruction.addressingMode, MOSAddressingModeImplied);
    }
}

- (void)testJump {
    // [OPCODE, LOW ADDRESS, HIGH ADDRESS]
    self.dataStream.data = @[@0x4c, @0x34, @0x12];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeJMP);
    XCTAssertEqual(instruction.operationName, @"Jump");
    XCTAssertEqual(instruction.absoluteAddress, (MOSAbsoluteAddress)0x1234);
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeAbsolute);
}

- (void)testBranchOnCarryClear {
    // [OPCODE, RELATIVE OFFSET]
    self.dataStream.data = @[@0x90, @0x0];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeBCC);
    XCTAssertEqual(instruction.operationName, @"BranchOnCarryClear");
    XCTAssertEqual(instruction.relativeAddress, (MOSRelativeAddress)0x0);
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeRelative);
}

- (void)testBranchOnCarrySet {
    // [OPCODE, RELATIVE OFFSET]
    self.dataStream.data = @[@0xB0, @0xFF];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeBCS);
    XCTAssertEqual(instruction.operationName, @"BranchOnCarrySet");
    XCTAssertEqual(instruction.relativeAddress, (MOSRelativeAddress)0xFF);
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeRelative);
}

- (void)testBranchOnResultZero {
    // [OPCODE, RELATIVE OFFSET]
    self.dataStream.data = @[@0xF0, @0xAB];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeBEQ);
    XCTAssertEqual(instruction.operationName, @"BranchOnResultZero");
    XCTAssertEqual(instruction.relativeAddress, (MOSRelativeAddress)0xAB);
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeRelative);
}

- (void)testBranchOnResultNotZero {
    // [OPCODE, RELATIVE OFFSET]
    self.dataStream.data = @[@0xD0, @0x12];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeBNE);
    XCTAssertEqual(instruction.operationName, @"BranchOnResultNotZero");
    XCTAssertEqual(instruction.relativeAddress, (MOSRelativeAddress)0x12);
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeRelative);
}

- (void)testINCZeroPage {
    // [OPCODE, OPERAND]
    self.dataStream.data = @[@0xE6, @0xDE];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeINCZeroPage);
    XCTAssertEqual(instruction.operationName, @"IncrementMemory");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeZeroPage);
    XCTAssertEqual(instruction.pageOffset, 0xDE);
}

- (void)testINCZeroPageIndexed {
    // [OPCODE, OPERAND]
    self.dataStream.data = @[@0xF6, @0x00];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeINCZeroPageIndexed);
    XCTAssertEqual(instruction.operationName, @"IncrementMemory");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeZeroPageX);
    XCTAssertEqual(instruction.pageOffset, 0x00);
}

- (void)testINCAbsolute {
    // [OPCODE, LOW ADDRESS, HIGH ADDRESS]
    self.dataStream.data = @[@0xEE, @0x78, @0x56];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeINCAbsolute);
    XCTAssertEqual(instruction.operationName, @"IncrementMemory");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeAbsolute);
    XCTAssertEqual(instruction.absoluteAddress, 0x5678);
}

- (void)testINCAbsoluteIndexedX {
    // [OPCODE, LOW ADDRESS, HIGH ADDRESS]
    self.dataStream.data = @[@0xFE, @0xFF, @0xFF];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeINCAbsoluteIndexed);
    XCTAssertEqual(instruction.operationName, @"IncrementMemory");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeAbsoluteIndexedX);
    XCTAssertEqual(instruction.absoluteAddress, 0xFFFF);
}

- (void)testANDImmediate {
    // [OPCODE, OPERAND]
    self.dataStream.data = @[@0x29, @0x45];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeANDImmediate);
    XCTAssertEqual(instruction.operationName, @"AND");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeImmediate);
    XCTAssertEqual(instruction.immediateValue, 0x45);
}

- (void)testANDZeroPage {
    // [OPCODE, OPERAND]
    self.dataStream.data = @[@0x25, @0x99];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeANDZeroPage);
    XCTAssertEqual(instruction.operationName, @"AND");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeZeroPage);
    XCTAssertEqual(instruction.pageOffset, 0x99);
}

- (void)testANDZeroPageIndexed {
    // [OPCODE, OPERAND]
    self.dataStream.data = @[@0x35, @0xFF];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeANDZeroPageIndexed);
    XCTAssertEqual(instruction.operationName, @"AND");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeZeroPageX);
    XCTAssertEqual(instruction.pageOffset, 0xFF);
}

- (void)testANDAbsolute {
    // [OPCODE, LOW ADDRESS, HIGH ADDRESS]
    self.dataStream.data = @[@0x2D, @0x45, @0x23];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeANDAbsolute);
    XCTAssertEqual(instruction.operationName, @"AND");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeAbsolute);
    XCTAssertEqual(instruction.absoluteAddress, 0x2345);
}

- (void)testLDXImmediate {
    // [OPCODE, OPERAND]
    self.dataStream.data = @[@0xA2, @0x12];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeLDXImmediate);
    XCTAssertEqual(instruction.operationName, @"LoadRegisterX");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeImmediate);
    XCTAssertEqual(instruction.immediateValue, 0x12);
}

- (void)testLDXAbsolute {
    // [OPCODE, LOW ADDRESS, HIGH ADDRESS]
    self.dataStream.data = @[@0xAE, @0xBA, @0xAB];

    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeLDXAbsolute);
    XCTAssertEqual(instruction.operationName, @"LoadRegisterX");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeAbsolute);
    XCTAssertEqual(instruction.absoluteAddress, 0xABBA);
}

- (void)testLDYImmediate {
    // [OPCODE, OPERAND]
    self.dataStream.data = @[@0xA0, @0x12];

    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeLDYImmediate);
    XCTAssertEqual(instruction.operationName, @"LoadRegisterY");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeImmediate);
    XCTAssertEqual(instruction.immediateValue, 0x12);
}

- (void)testCPXImmediate {
    // [OPCODE, OPERAND]
    self.dataStream.data = @[@0xE0, @0x99];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeCPXImmediate);
    XCTAssertEqual(instruction.operationName, @"CompareX");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeImmediate);
    XCTAssertEqual(instruction.immediateValue, 0x99);
}

- (void)testCPYImmediate {
    // [OPCODE, OPERAND]
    self.dataStream.data = @[@0xC0, @0x99];

    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeCPYImmediate);
    XCTAssertEqual(instruction.operationName, @"CompareY");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeImmediate);
    XCTAssertEqual(instruction.immediateValue, 0x99);
}

- (void)testJSR {
    // [OPCODE, ADDRESS LOW, ADDRESS HIGH]
    self.dataStream.data = @[@0x20, @0x34, @0x12];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeJSR);
    XCTAssertEqual(instruction.operationName, @"JumpToSubroutine");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeAbsolute);
    XCTAssertEqual(instruction.absoluteAddress, 0x1234);
}

- (void)testLDAImmediate {
    // [OPCODE, VALUE]
    self.dataStream.data = @[@0xA9, @0x34];

    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeLDAImmediate);
    XCTAssertEqual(instruction.operationName, @"LoadAccumulator");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeImmediate);
    XCTAssertEqual(instruction.immediateValue, 0x34);
}

- (void)testLDAZeroPage {
    // [OPCODE, PAGE OFFSET]
    self.dataStream.data = @[@0xA5, @0x22];

    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeLDAZeroPage);
    XCTAssertEqual(instruction.operationName, @"LoadAccumulator");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeZeroPage);
    XCTAssertEqual(instruction.pageOffset, 0x22);
}

- (void)testLDAAbsolute {
    // [OPCODE, ADDRESS LOW, ADDRESS HIGH]
    self.dataStream.data = @[@0xAD, @0x31, @0xA0];

    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeLDAAbsolute);
    XCTAssertEqual(instruction.operationName, @"LoadAccumulator");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeAbsolute);
    XCTAssertEqual(instruction.absoluteAddress, 0xA031);
}

- (void)testLDAIndirectIndexed {
    // [OPCODE, PAGE OFFSET]
    self.dataStream.data = @[@0xB1, @0x05];

    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeLDAIndirectIndexed);
    XCTAssertEqual(instruction.operationName, @"LoadAccumulator");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeIndirectIndexed);
    XCTAssertEqual(instruction.pageOffset, 0x05);
}

- (void)testSTXZeroPage {
    // [OPCODE, PAGE OFFSET]
    self.dataStream.data = @[@0x86, @0x05];

    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeSTXZeroPage);
    XCTAssertEqual(instruction.operationName, @"StoreRegisterX");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeZeroPage);
    XCTAssertEqual(instruction.pageOffset, 0x05);
}

- (void)testSTAZeroPage {
    // [OPCODE, PAGE OFFSET]
    self.dataStream.data = @[@0x85, @0x22];

    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeSTAZeroPage);
    XCTAssertEqual(instruction.operationName, @"StoreAccumulator");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeZeroPage);
    XCTAssertEqual(instruction.pageOffset, 0x22);
}

- (void)testSTAIndirectIndexed {
    // [OPCODE, PAGE OFFSET]
    self.dataStream.data = @[@0x91, @0x55];

    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeSTAIndirectIndexed);
    XCTAssertEqual(instruction.operationName, @"StoreAccumulator");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeIndirectIndexed);
    XCTAssertEqual(instruction.pageOffset, 0x55);
}

- (void)testSTAAbsoluteIndexedX {
    // [OPCODE, LOW ADDRESS, HIGH ADDRESS]
    self.dataStream.data = @[@0x9D, @0xF9, @0xF5];

    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeSTAAbsoluteIndexedX);
    XCTAssertEqual(instruction.operationName, @"StoreAccumulator");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeAbsoluteIndexedX);
    XCTAssertEqual(instruction.absoluteAddress, 0xF5F9);
}

@end
