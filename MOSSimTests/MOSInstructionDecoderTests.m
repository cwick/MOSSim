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
    self.dataStream.data = @[@0x4c, @0x34, @0x12];
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    XCTAssertEqual(instruction.opcode, MOSOPCodeJump);
    XCTAssertEqual(instruction.address, (MOSAddress)0x1234);
}

@end
