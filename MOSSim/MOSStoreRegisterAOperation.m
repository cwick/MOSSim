#import "MOSStoreRegisterAOperation.h"
#import "MOSCPU.h"
#import "MOSUtils.h"
#import "MOSInstructionDecoder.h"

@implementation MOSStoreRegisterAOperation

- (void)execute:(MOSCPU *)cpu {
    MOSAbsoluteAddress address = [self.instruction resolveAddress:cpu];
    [cpu writeWord:cpu.registerValues.a toAddress:address];
}

@end
