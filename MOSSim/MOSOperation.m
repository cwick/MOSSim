#import "MOSOperation.h"
#import "MOSInstruction.h"

@implementation MOSOperation

+ (MOSOperation *)operationFromInstruction:(MOSInstruction *)instruction {
    Class klass = NSClassFromString([NSString stringWithFormat:@"MOS%@Operation", instruction.operationName]);
    if (!klass) {
        [NSException raise:@"Unknown operation" format:@"%@", instruction.operationName];
    }
    return [[klass alloc] initWithInstruction:instruction];
}

- (instancetype)initWithInstruction:(MOSInstruction *)instruction {
    self = [super init];
    if (self) {
        _instruction = instruction;
    }
    return self;
}

- (void)execute:(MOSCPU *)cpu {
    [self doesNotRecognizeSelector:_cmd];
}

@end