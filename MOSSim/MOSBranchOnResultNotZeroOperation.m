#import "MOSBranchOnResultNotZeroOperation.h"
#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"

@interface MOSBranchOnResultNotZeroOperation ()

@property MOSRelativeAddress offset;

@end

@implementation MOSBranchOnResultNotZeroOperation

- (instancetype)initWithInstruction:(MOSInstruction* )instruction {
    self = [super init];
    if (self) {
        _offset = instruction.relativeAddress;
    }
    return self;
}

- (instancetype)initWithRelativeAddress:(MOSRelativeAddress)address {
    MOSInstruction *i = [MOSInstruction new];
    i.relativeAddress = address;
    return [self initWithInstruction:i];
}

- (void)execute:(MOSCPU *)cpu {
    if (!cpu.statusRegister.zeroFlag) {
        cpu.programCounter += self.offset;
    }
}

@end
