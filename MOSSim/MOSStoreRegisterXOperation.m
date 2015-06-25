#import "MOSStoreRegisterXOperation.h"
#import "MOSCPU.h"
#import "MOSUtils.h"
#import "MOSInstructionDecoder.h"

@implementation MOSStoreRegisterXOperation

- (instancetype)initWithInstruction:(MOSInstruction *)instruction {
    return self = [super initWithInstruction:instruction register:@"x"];
}

@end
