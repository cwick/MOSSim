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
    MOSImmediateValue value = self.instruction.immediateValue;
    [cpu.registerValues setValue:@(value) forKey:self.registerToLoad];
    cpu.statusRegister.zeroFlag = (value == 0);
    cpu.statusRegister.negativeFlag = MOSTest7thBit(value);
}

@end
