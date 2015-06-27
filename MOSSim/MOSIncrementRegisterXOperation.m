#import "MOSIncrementRegisterXOperation.h"
#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"
#import "MOSUtils.h"

@implementation MOSIncrementRegisterXOperation

- (instancetype)initWithInstruction:(MOSInstruction *)instruction {
    return self = [super initWithInstruction:instruction register:@"x"];
}

@end
