#import "MOSOperation.h"
#import "MOSInstruction.h"
#import "MOSJumpOperation.h"

@implementation MOSOperation

+ (MOSOperation *)operationFromInstruction:(MOSInstruction *)instruction {
    Class klass = NSClassFromString([NSString stringWithFormat:@"MOS%@Operation", instruction.operationName]);
    return [[klass alloc] initWithInstruction:instruction];
}

- (instancetype)initWithInstruction:(MOSInstruction *)instruction {
    self = [super init];
    return self;
}

- (void)execute:(MOSCPU *)cpu {
    
}

@end