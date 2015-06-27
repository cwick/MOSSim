#import "MOSIncrementRegisterYOperation.h"
#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"
#import "MOSUtils.h"

@implementation MOSIncrementRegisterYOperation

- (instancetype)initWithInstruction:(MOSInstruction *)instruction {
    return self = [super initWithInstruction:instruction register:@"y"];
}

@end
