#import "MOSStoreRegisterOperation.h"
#import "MOSCPU.h"
#import "MOSInstruction.h"

@implementation MOSStoreRegisterOperation

- (instancetype)initWithInstruction:(MOSInstruction *)instruction register:(NSString *)reg {
    self = [super initWithInstruction:instruction];
    if (self) {
        _registerToStore = reg;
    }

    return self;
}

- (void)execute:(MOSCPU *)cpu {
    MOSAbsoluteAddress address = [self.instruction resolveAddress:cpu];
    MOSRegisterValue value = (MOSRegisterValue) [[cpu.registerValues valueForKey:self.registerToStore] integerValue];
    [cpu writeWord:value toAddress:address];
}

@end
