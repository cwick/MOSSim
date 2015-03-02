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
        [NSException raise:@"IMPLEMENT ME" format:@""];
    }
    return self;
}

- (instancetype)initWithRelativeAddress:(MOSRelativeAddress)address {
    self = [super init];
    if (self) {
        _offset = address;
    }
    
    return self;
}

- (void)execute:(MOSCPU *)cpu {
    if (!cpu.statusRegister.zeroFlag) {
        cpu.programCounter += self.offset;
    }
}

@end
