#import "MOSLoadRegisterOperation.h"
#import "MOSCPU.h"
#import "MOSTypes.h"
#import "MOSRegisterBank.h"

@implementation MOSLoadRegisterOperation

- (instancetype)initWithImmediateValue:(MOSImmediateValue)value {
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

- (void)execute:(MOSCPU *)cpu {
    cpu.registers.x = self.value;
}

@end
