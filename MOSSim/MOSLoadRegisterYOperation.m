#import "MOSLoadRegisterYOperation.h"
#import "MOSInstructionDecoder.h"

@implementation MOSLoadRegisterYOperation

- (instancetype)initWithInstruction:(MOSInstruction* )instruction {
    self = [super initWithInstruction:instruction register:@"y"];
    return self;
}

@end
