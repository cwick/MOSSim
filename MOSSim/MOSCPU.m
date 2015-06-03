#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"
#import "MOSOperation.h"
#import "MOSUtils.h"
#import "MOSReadWriteMemory.h"

const NSUInteger MOS_ADDRESS_SPACE_SIZE = 1 << 16;

@interface MOSCPU () <MOSDataStream>

@property(nonatomic) MOSInstructionDecoder *decoder;

@end

@implementation MOSCPU

- (instancetype)init {
    self = [super init];
    if (self) {
        _statusRegister = [MOSStatusRegister new];
        _registerValues = [MOSRegisterValues new];
        _decoder = [[MOSInstructionDecoder alloc] initWithDataStream:self];
        _dataBus = [MOSReadWriteMemory new];
    }
    
    return self;
}

- (void)step {
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    MOSOperation *operation = [MOSOperation operationFromInstruction:instruction];
    
    [operation execute:self];
}

- (MOSWord)nextWord {
    return [self readWordFromAddress:self.programCounter++];
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
    return [self.dataBus readWordFromAddress:address];
}

- (void)writeWord:(MOSWord)value toAddress:(MOSAbsoluteAddress)address {
    [self.dataBus writeWord:value toAddress:address];
}

- (void)pushStack:(MOSWord)value {
    MOSAbsoluteAddress address = [self createStackAddress:self.stackPointer--];
    [self.dataBus writeWord:value toAddress:address];
}

- (MOSWord)popStack {
    MOSAbsoluteAddress address = [self createStackAddress:++self.stackPointer];
    return [self readWordFromAddress:address];
}

- (MOSAbsoluteAddress)createStackAddress:(MOSWord)stackPointer {
    // The stack starts on page 0x01
    return MOSAbsoluteAddressMake(stackPointer, 0x01);
}

@end
