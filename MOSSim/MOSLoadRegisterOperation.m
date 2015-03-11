#import "MOSLoadRegisterOperation.h"
#import "MOSCPU.h"
#import "MOSTypes.h"
#import "MOSInstructionDecoder.h"
#import "MOSUtils.h"

@implementation MOSLoadRegisterOperation

- (instancetype)initWithImmediateValue:(MOSImmediateValue)value register:(NSString *)reg{
    self = [super init];
    if (self) {
        _value = value;
        _registerToLoad = reg;
    }
    return self;
}

- (void)execute:(MOSCPU *)cpu {
    [cpu.registerValues setValue:@(self.value) forKey:self.registerToLoad];
    cpu.statusRegister.zeroFlag = (self.value == 0);
    cpu.statusRegister.negativeFlag = MOSTest7thBit(self.value);
}

@end
