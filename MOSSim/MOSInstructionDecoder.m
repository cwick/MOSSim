#import "MOSInstructionDecoder.h"
#import "MOSInstruction.h"

static const int BITS_PER_BYTE = 8;

MOSAbsoluteAddress MOSAbsoluteAddressMake(MOSWord high, MOSWord low) {
    return (high << BITS_PER_BYTE) | low;
}

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
    MOSInstruction *instruction = [[MOSInstruction alloc] initWithOPCode:opcode decoder:self];
    
    return instruction;
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
    
    return MOSAbsoluteAddressMake(addressHigh, addressLow);
}

@end
