#import "MOSStoreAccumulatorOperation.h"
#import "MOSCPU.h"
#import "MOSUtils.h"
#import "MOSInstructionDecoder.h"

@implementation MOSStoreAccumulatorOperation

- (void)execute:(MOSCPU *)cpu {
    MOSAbsoluteAddress address = [self.instruction resolveAddress:cpu];
    [cpu writeWord:cpu.registerValues.a toAddress:address];
}

@end
