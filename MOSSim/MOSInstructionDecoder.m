#import "MOSInstructionDecoder.h"

static const int BITS_PER_BYTE = 8;

MOSAddress MOSAddressMake(MOSWord high, MOSWord low) {
    return (high << BITS_PER_BYTE) | low;
}

@implementation MOSInstruction
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
    MOSInstruction *instruction = [MOSInstruction new];
    instruction.opcode = (MOSOPCode)[self.dataStream nextWord];
    
    switch (instruction.opcode) {
        case MOSOPCodeJump:
            instruction.address = [self decodeJumpInstruction];
            break;
        default:
            break;
    }
    
    return instruction;
}

- (MOSAddress)decodeJumpInstruction {
    MOSWord addressLow = [self.dataStream nextWord];
    MOSWord addressHigh = [self.dataStream nextWord];
    
    return MOSAddressMake(addressHigh, addressLow);
}

@end
