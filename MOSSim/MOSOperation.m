#import "MOSOperation.h"
#import "MOSJumpOperation.h"
#import "MOSInstructionDecoder.h"

@implementation MOSOperation

+ (MOSOperation *)operationFromInstruction:(MOSInstruction *)instruction {
    Class klass = NSClassFromString([NSString stringWithFormat:@"MOS%@Operation", instruction.operationName]);
    if (!klass) {
        [NSException raise:@"Unknown operation" format:@"%@", instruction.operationName];
    }
    return [[klass alloc] initWithInstruction:instruction];
}

- (void)execute:(MOSCPU *)cpu {
    
}

@end