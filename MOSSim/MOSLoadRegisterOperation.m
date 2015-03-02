#import "MOSLoadRegisterOperation.h"
#import "MOSCPU.h"
#import "MOSTypes.h"
#import "MOSInstructionDecoder.h"

@implementation MOSLoadRegisterOperation

- (instancetype)initWithInstruction:(MOSInstruction* )instruction {
    self = [super init];
    if (self) {
        [NSException raise:@"IMPLEMENT ME" format:@""];
    }
    return self;
}

- (instancetype)initWithImmediateValue:(MOSImmediateValue)value {
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

- (void)execute:(MOSCPU *)cpu {
    cpu.registerValues.x = self.value;
}

@end
