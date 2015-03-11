#import "MOSLoadRegisterXOperation.h"
#import "MOSInstructionDecoder.h"

@implementation MOSLoadRegisterXOperation

- (instancetype)initWithInstruction:(MOSInstruction* )instruction {
    return [self initWithImmediateValue:instruction.immediateValue];
}

- (instancetype)initWithImmediateValue:(MOSImmediateValue)value {
    self = [super initWithImmediateValue:value register:@"x"];
    return self;
}

@end
