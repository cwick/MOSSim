#import "MOSCompareYOperation.h"

@implementation MOSCompareYOperation

- (instancetype)initWithInstruction:(MOSInstruction* )instruction {
    return self = [super initWithInstruction:instruction register:@"y"];
}

@end
