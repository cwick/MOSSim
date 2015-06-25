#import "MOSLoadAccumulatorOperation.h"

@implementation MOSLoadAccumulatorOperation

- (instancetype)initWithInstruction:(MOSInstruction *)instruction {
    return self = [super initWithInstruction:instruction register:@"a"];
}

@end
