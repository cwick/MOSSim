#import <XCTest/XCTest.h>

#import "MOSInstructionDecoder.h"

@interface MOSInstructionDecoderTests : XCTestCase

@property (nonatomic) MOSInstructionDecoder *decoder;

@end

@implementation MOSInstructionDecoderTests

- (void)setUp {
    self.decoder = [MOSInstructionDecoder new];
}

- (void)testClearCarryFlag {
    MOSOPCode opcode = [self.decoder decodeInstruction:0x18];
    XCTAssertEqual(opcode, MOSOPCodeClearCarryFlag);
}

- (void)testSetCarryFlag {
    MOSOPCode opcode = [self.decoder decodeInstruction:0x38];
    XCTAssertEqual(opcode, MOSOPCodeSetCarryFlag);
}

- (void)testClearDecimalMode {
    MOSOPCode opcode = [self.decoder decodeInstruction:0xD8];
    XCTAssertEqual(opcode, MOSOPCodeClearDecimalMode);
}

@end
