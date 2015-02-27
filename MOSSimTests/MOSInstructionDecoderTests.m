#import <XCTest/XCTest.h>

#import "MOSInstructionDecoder.h"

@interface MOSFakeDataStream : NSObject<MOSDataStream>

@property(nonatomic) NSArray* data;
@property(nonatomic) NSInteger location;

@end

@implementation MOSFakeDataStream

- (MOSWord)nextWord {
    NSNumber *next = self.data[self.location++];
    return [next unsignedCharValue];
}

- (void)setData:(NSArray *)data {
    _data = data;
    self.location = 0;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _data = @[];
        _location = 0;
    }
    
    return self;
}

@end

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
    NSDictionary *expected = @{@0x18: @[@(MOSOPCodeCLC), @(MOSOperationClearCarryFlag)],
                               @0x38: @[@(MOSOPCodeSEC), @(MOSOperationSetCarryFlag)],
                               @0xD8: @[@(MOSOPCodeCLD), @(MOSOperationClearDecimalMode)] };
    
    for (NSNumber *opcode in expected.allKeys) {
        self.dataStream.data = @[@(opcode.unsignedCharValue)];
        MOSInstruction *instruction = [self.decoder decodeNextInstruction];
        XCTAssertEqual(@(instruction.opcode), expected[opcode][0],
                       @"failed to decode opcode %@", opcode);
        XCTAssertEqual(@(instruction.operation), expected[opcode][1]);
        XCTAssertEqual(instruction.addressingMode, MOSAddressingModeImplied);
    }
}

- (void)testJump {
    // [OPCODE, LOW ADDRESS, HIGH ADDRESS]
    self.dataStream.data = @[@0x4c, @0x34, @0x12];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeJMP);
    XCTAssertEqual(instruction.operation, MOSOperationJump);
    XCTAssertEqual(instruction.absoluteAddress, (MOSAbsoluteAddress)0x1234);
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeAbsolute);
}

- (void)testBranchOnCarryClear {
    // [OPCODE, RELATIVE OFFSET]
    self.dataStream.data = @[@0x90, @0x0];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeBCC);
    XCTAssertEqual(instruction.operation, MOSOperationBranchOnCarryClear);
    XCTAssertEqual(instruction.relativeAddress, (MOSRelativeAddress)0x0);
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeRelative);
}

- (void)testBranchOnCarrySet {
    // [OPCODE, RELATIVE OFFSET]
    self.dataStream.data = @[@0xB0, @0xFF];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeBCS);
    XCTAssertEqual(instruction.operation, MOSOperationBranchOnCarrySet);
    XCTAssertEqual(instruction.relativeAddress, (MOSRelativeAddress)0xFF);
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeRelative);
}

- (void)testBranchOnResultZero {
    // [OPCODE, RELATIVE OFFSET]
    self.dataStream.data = @[@0xF0, @0xAB];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeBEQ);
    XCTAssertEqual(instruction.operation, MOSOperationBranchOnResultZero);
    XCTAssertEqual(instruction.relativeAddress, (MOSRelativeAddress)0xAB);
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeRelative);
}

- (void)testBranchOnResultNotZero {
    // [OPCODE, RELATIVE OFFSET]
    self.dataStream.data = @[@0xD0, @0x12];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeBNE);
    XCTAssertEqual(instruction.operation, MOSOperationBranchOnResultNotZero);
    XCTAssertEqual(instruction.relativeAddress, (MOSRelativeAddress)0x12);
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeRelative);
}

- (void)testIncrementMemoryByOneZeroPage {
    // [OPCODE, OPERAND]
    self.dataStream.data = @[@0xE6, @0xDE];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeINCZeroPage);
    XCTAssertEqual(instruction.operation, MOSOperationIncrementByOne);
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeZeroPage);
    XCTAssertEqual(instruction.pageOffset, 0xDE);
}

- (void)testIncrementMemoryByOneZeroPageIndexed {
    // [OPCODE, OPERAND]
    self.dataStream.data = @[@0xF6, @0x00];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeINCZeroPageIndexed);
    XCTAssertEqual(instruction.operation, MOSOperationIncrementByOne);
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeZeroPage);
    XCTAssertEqual(instruction.isAddressingModeIndexed, YES);
    XCTAssertEqual(instruction.pageOffset, 0x00);
}

- (void)testIncrementMemoryByOneAbsolute {
    // [OPCODE, LOW ADDRESS, HIGH ADDRESS]
    self.dataStream.data = @[@0xEE, @0x78, @0x56];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeINCAbsolute);
    XCTAssertEqual(instruction.operation, MOSOperationIncrementByOne);
    XCTAssertEqual(instruction.addressingMode, MOSAddressingModeAbsolute);
    XCTAssertEqual(instruction.absoluteAddress, 0x5678);
}

@end
