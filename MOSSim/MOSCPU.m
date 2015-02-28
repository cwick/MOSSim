#import "MOSCPU.h"
#import "MOSStatusRegister.h"
#import "MOSInstructionDecoder.h"
#import "MOSInstruction.h"

@interface MOSCPU ()

@property(nonatomic) id<MOSDataStream> program;
@property(nonatomic) MOSInstructionDecoder *decoder;

@end

@implementation MOSCPU

- (instancetype)init {
    self = [super init];
    if (self) {
        _statusRegister = [MOSStatusRegister new];
        _registerValues = [MOSRegisterValues new];
    }
    
    return self;
}

- (void)loadProgram:(id<MOSDataStream>)program {
    self.decoder = [[MOSInstructionDecoder alloc] initWithDataStream:program];
}

- (void)step {
    MOSInstruction *instruction = [self.decoder decodeNextInstruction];
}

- (void)run {
}

@end
