#import "MOSCPU.h"
#import "MOSStatusRegister.h"
#import "MOSInstructionDecoder.h"
#import "MOSOperation.h"

@interface MOSCPU () <MOSDataStream>

@property(nonatomic) NSData *program;
@property(nonatomic) MOSInstructionDecoder *decoder;

@end

@implementation MOSCPU

- (instancetype)init {
    self = [super init];
    if (self) {
        _statusRegister = [MOSStatusRegister new];
        _registerValues = [MOSRegisterValues new];
        _decoder = [[MOSInstructionDecoder alloc] initWithDataStream:self];
    }
    
    return self;
}

- (void)loadProgram:(NSData *)data {
    self.program = data;
}

- (void)step {
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
    MOSOperation *operation = [MOSOperation operationFromInstruction:instruction];
    
    [operation execute:self];
    NSLog(@"%@", self);
}

- (MOSWord)nextWord {
    const MOSWord *programData = self.program.bytes;
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

@end
