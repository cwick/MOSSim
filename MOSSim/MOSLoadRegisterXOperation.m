#import "MOSLoadRegisterXOperation.h"
#import "MOSInstructionDecoder.h"

@implementation MOSLoadRegisterXOperation

- (instancetype)initWithInstruction:(MOSInstruction* )instruction {
    return self = [super initWithInstruction:instruction register:@"x"];
}

@end
