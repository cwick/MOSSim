#import "MOSCompareOperation.h"
#import "MOSCPU.h"

@implementation MOSCompareOperation

- (instancetype)initWithImmediateValue:(MOSImmediateValue)value {
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

- (void)execute:(MOSCPU *)cpu {
    cpu.statusRegister.zeroFlag = self.value == cpu.registerValues.x;
}

@end
