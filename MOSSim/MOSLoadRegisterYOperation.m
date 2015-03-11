#import "MOSLoadRegisterYOperation.h"
#import "MOSInstructionDecoder.h"

@implementation MOSLoadRegisterYOperation

- (instancetype)initWithInstruction:(MOSInstruction* )instruction {
    return [self initWithImmediateValue:instruction.immediateValue];
}

- (instancetype)initWithImmediateValue:(MOSImmediateValue)value {
    self = [super initWithImmediateValue:value register:@"y"];
    return self;
}

@end
