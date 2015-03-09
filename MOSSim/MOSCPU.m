#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"
#import "MOSOperation.h"
#import "MOSUtils.h"

static const int MOS_ADDRESS_SPACE_SIZE = 1 << 16;

@interface MOSCPU () <MOSDataStream>

@property(nonatomic) NSMutableData *addressSpace;
@property(nonatomic) MOSInstructionDecoder *decoder;

@end

@implementation MOSCPU

- (instancetype)init {
    self = [super init];
    if (self) {
        _addressSpace = [NSMutableData dataWithLength:MOS_ADDRESS_SPACE_SIZE];
        _statusRegister = [MOSStatusRegister new];
        _registerValues = [MOSRegisterValues new];
        _decoder = [[MOSInstructionDecoder alloc] initWithDataStream:self];
    }
    
    return self;
}

- (void)loadProgram:(NSData *)data {
    self.addressSpace = [NSMutableData dataWithLength:MOS_ADDRESS_SPACE_SIZE];
    [self.addressSpace replaceBytesInRange:NSMakeRange(0, data.length) withBytes:data.bytes];
}

- (void)step {
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    MOSOperation *operation = [MOSOperation operationFromInstruction:instruction];
    
    [operation execute:self];
}

- (MOSWord)nextWord {
    const MOSWord *programData = self.addressSpace.bytes;
    return programData[self.programCounter++];
}

- (void)run {
    while (!self.isHalted) {
        [self step];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:
            @"\nPC\t0x%X\t%d\n"
            @"X\t0x%X\t%d", self.programCounter, self.programCounter, self.registerValues.x, self.registerValues.x];
}

- (MOSWord)readWordFromAddress:(MOSAbsoluteAddress)address {
    return ((MOSWord *)self.addressSpace.bytes)[address];
}

- (void)writeWord:(MOSWord)value toAddress:(MOSAbsoluteAddress)address {
    ((MOSWord *)self.addressSpace.bytes)[address] = value;
}

- (void)pushStack:(MOSWord)value {
    MOSAbsoluteAddress address = [self createStackAddress:self.stackPointer--];
    ((MOSWord *)self.addressSpace.mutableBytes)[address] = value;
}

- (MOSWord)popStack {
    MOSAbsoluteAddress address = [self createStackAddress:++self.stackPointer];
    return ((MOSWord *)self.addressSpace.bytes)[address];
}

- (MOSAbsoluteAddress)createStackAddress:(MOSWord)stackPointer {
    return MOSAbsoluteAddressMake(0x01, stackPointer);
}

@end
