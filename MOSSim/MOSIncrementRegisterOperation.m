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
    registerValue += 1;

    [cpu.registerValues setValue:@(registerValue) forKey:self.registerToIncrement];
    cpu.statusRegister.zeroFlag = (registerValue == 0);
    cpu.statusRegister.negativeFlag = MOSTestHighBit(registerValue);
}

@end
