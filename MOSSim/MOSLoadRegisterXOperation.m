#import "MOSLoadRegisterXOperation.h"
#import "MOSInstructionDecoder.h"

@implementation MOSLoadRegisterXOperation

- (instancetype)initWithInstruction:(MOSInstruction* )instruction {
    self = [super initWithInstruction:instruction register:@"x"];
    return self;
}

@end
