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
                               @0xE8: @[@(MOSOPCodeINX), @"IncrementRegister"],
                               @0x60: @[@(MOSOPCodeRTS), @"ReturnFromSubroutine"] };
    
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

- (void)testIncrementMemoryByOneZeroPage {
    // [OPCODE, OPERAND]
    self.dataStream.data = @[@0xE6, @0xDE];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeINCZeroPage);
    XCTAssertEqual(instruction.operationName, @"IncrementByOne");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeZeroPage);
    XCTAssertEqual(instruction.pageOffset, 0xDE);
}

- (void)testIncrementMemoryByOneZeroPageIndexed {
    // [OPCODE, OPERAND]
    self.dataStream.data = @[@0xF6, @0x00];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeINCZeroPageIndexed);
    XCTAssertEqual(instruction.operationName, @"IncrementByOne");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeZeroPage);
    XCTAssertEqual(instruction.isAddressingModeIndexed, YES);
    XCTAssertEqual(instruction.pageOffset, 0x00);
}

- (void)testIncrementMemoryByOneAbsolute {
    // [OPCODE, LOW ADDRESS, HIGH ADDRESS]
    self.dataStream.data = @[@0xEE, @0x78, @0x56];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeINCAbsolute);
    XCTAssertEqual(instruction.operationName, @"IncrementByOne");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeAbsolute);
    XCTAssertEqual(instruction.absoluteAddress, 0x5678);
}

- (void)testIncrementMemoryByOneAbsoluteIndexed {
    // [OPCODE, LOW ADDRESS, HIGH ADDRESS]
    self.dataStream.data = @[@0xFE, @0xFF, @0xFF];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeINCAbsoluteIndexed);
    XCTAssertEqual(instruction.operationName, @"IncrementByOne");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeAbsolute);
    XCTAssertEqual(instruction.isAddressingModeIndexed, YES);
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
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeZeroPage);
    XCTAssertEqual(instruction.isAddressingModeIndexed, YES);
    XCTAssertEqual(instruction.pageOffset, 0xFF);
}

- (void)testANDAbsolute {
    // [OPCODE, LOW ADDRESS, HIGH ADDRESS]
    self.dataStream.data = @[@0x2D, @0x45, @0x23];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeANDAbsolute);
    XCTAssertEqual(instruction.operationName, @"AND");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeAbsolute);
    XCTAssertEqual(instruction.isAddressingModeIndexed, NO);
    XCTAssertEqual(instruction.absoluteAddress, 0x2345);
}

- (void)testLDXImmediate {
    // [OPCODE, OPERAND]
    self.dataStream.data = @[@0xA2, @0x12];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeLDXImmediate);
    XCTAssertEqual(instruction.operationName, @"LoadRegister");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeImmediate);
    XCTAssertEqual(instruction.immediateValue, 0x12);
}

- (void)testCPXImmediate {
    // [OPCODE, OPERAND]
    self.dataStream.data = @[@0xE0, @0x99];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeCPXImmediate);
    XCTAssertEqual(instruction.operationName, @"Compare");
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeImmediate);
    XCTAssertEqual(instruction.immediateValue, 0x99);
}

@end
