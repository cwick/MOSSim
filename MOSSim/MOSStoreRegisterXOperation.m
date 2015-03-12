#import "MOSStoreRegisterXOperation.h"
#import "MOSCPU.h"
#import "MOSUtils.h"
#import "MOSInstructionDecoder.h"

@implementation MOSStoreRegisterXOperation

- (void)execute:(MOSCPU *)cpu {
    MOSAbsoluteAddress address = [self.instruction resolveAddress:cpu];
    [cpu writeWord:cpu.registerValues.x toAddress:address];
}

@end
