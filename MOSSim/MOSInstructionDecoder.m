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
            instruction.address = [self decodeAddress];
            break;
        case MOSOPCodeBranchOnCarryClear:
        case MOSOPCodeBranchOnCarrySet:
        case MOSOPCodeBranchOnResultZero:
        case MOSOPCodeBranchOnResultNotZero:
            instruction.relativeAddress = [self decodeRelativeAddress];
            break;
        default:
            break;
    }
    
    return instruction;
}

- (MOSRelativeAddress)decodeRelativeAddress {
    return (MOSRelativeAddress)[self.dataStream nextWord];
}

- (MOSAddress)decodeAddress {
    MOSWord addressLow = [self.dataStream nextWord];
    MOSWord addressHigh = [self.dataStream nextWord];
    
    return MOSAddressMake(addressHigh, addressLow);
}

@end
