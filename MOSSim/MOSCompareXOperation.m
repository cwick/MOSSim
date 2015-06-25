#import "MOSCompareXOperation.h"

@implementation MOSCompareXOperation

- (instancetype)initWithInstruction:(MOSInstruction* )instruction {
    self = [super initWithInstruction:instruction register:@"x"];
    return self;
}


@end
