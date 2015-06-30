#import "MOSLoadRegisterOperation.h"
#import "MOSCPU.h"
#import "MOSTypes.h"
#import "MOSInstructionDecoder.h"
#import "MOSUtils.h"

@implementation MOSLoadRegisterOperation

- (instancetype)initWithInstruction:(MOSInstruction *)instruction register:(NSString *)reg {
    self = [super initWithInstruction:instruction];
    if (self) {
        _registerToLoad = reg;
    }
    return self;
}

- (void)execute:(MOSCPU *)cpu {
    MOSRegisterValue value;
    if (self.instruction.addressingMode == MOSAddressingModeImmediate) {
        value = self.instruction.immediateValue;
    } else {
        MOSAbsoluteAddress address = [self.instruction resolveAddress:cpu];
        value = [cpu readWordFromAddress:address];
    }

    [cpu.registerValues setValue:@(value) forKey:self.registerToLoad];
    [cpu.statusRegister setZeroAndNegativeFlagsFromValue:value];
}

@end
