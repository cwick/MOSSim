#import "MOSIncrementRegisterOperation.h"
#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"
#import "MOSUtils.h"

@implementation MOSIncrementRegisterOperation


- (id)initWithInstruction:(MOSInstruction *)instruction register:(NSString *)reg {
    self = [super initWithInstruction:instruction];

    if (self) {
        self.registerToIncrement = reg;
    }

    return self;
}

- (void)execute:(MOSCPU *)cpu {
    MOSRegisterValue registerValue = (MOSRegisterValue) [[cpu.registerValues valueForKey:self.registerToIncrement] integerValue];
    MOSRegisterValue incrementedRegisterValue = (registerValue + (MOSRegisterValue)1);

    [cpu.registerValues setValue:@(incrementedRegisterValue) forKey:self.registerToIncrement];
    [cpu.statusRegister setZeroAndNegativeFlagsFromValue:incrementedRegisterValue];
}

@end
