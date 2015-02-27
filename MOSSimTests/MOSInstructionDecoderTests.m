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
    NSDictionary *opcodes = @{@0x18: @(MOSOPCodeClearCarryFlag),
                              @0x38: @(MOSOPCodeSetCarryFlag),
                              @0xD8: @(MOSOPCodeClearDecimalMode) };
    
    for (NSNumber *opcode in opcodes.allKeys) {
        self.dataStream.data = @[@(opcode.unsignedCharValue)];
        MOSInstruction *instruction = [self.decoder decodeNextInstruction];
        XCTAssertEqual(@(instruction.opcode), opcodes[opcode],
                       @"failed to decode opcode %@", opcode);
    }
}

- (void)testJump {
    // [OPCODE, LOW ADDRESS, HIGH ADDRESS]
    self.dataStream.data = @[@0x4c, @0x34, @0x12];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeJump);
    XCTAssertEqual(instruction.address, (MOSAddress)0x1234);
}

- (void)testBranchOnCarryClear {
    // [OPCODE, RELATIVE OFFSET]
    self.dataStream.data = @[@0x90, @0x0];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeBranchOnCarryClear);
    XCTAssertEqual(instruction.relativeAddress, (MOSRelativeAddress)0x0);
}

- (void)testBranchOnCarrySet {
    // [OPCODE, RELATIVE OFFSET]
    self.dataStream.data = @[@0xB0, @0xFF];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeBranchOnCarrySet);
    XCTAssertEqual(instruction.relativeAddress, (MOSRelativeAddress)0xFF);
}

- (void)testBranchOnResultZero {
    // [OPCODE, RELATIVE OFFSET]
    self.dataStream.data = @[@0xF0, @0xAB];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeBranchOnResultZero);
    XCTAssertEqual(instruction.relativeAddress, (MOSRelativeAddress)0xAB);
}

- (void)testBranchOnResultNotZero {
    // [OPCODE, RELATIVE OFFSET]
    self.dataStream.data = @[@0xD0, @0x12];
    
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeBranchOnResultNotZero);
    XCTAssertEqual(instruction.relativeAddress, (MOSRelativeAddress)0x12);
}
@end
