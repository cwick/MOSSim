#import "MOSJumpToSubroutineOperation.h"
#import "MOSCPU.h"
#import "MOSUtils.h"

@interface MOSJumpToSubroutineOperation ()

@property(nonatomic) MOSAbsoluteAddress address;

@end

@implementation MOSJumpToSubroutineOperation

- (instancetype)initWithAbsoluteAddress:(MOSAbsoluteAddress)address {
    self = [super init];
    if (self) {
        _address = address;
    }
    
    return self;
}

- (void)execute:(MOSCPU *)cpu {
    MOSAbsoluteAddress returnAddress = cpu.programCounter - 1;
    
    [cpu pushStack:MOSAddressHigh(returnAddress)];
    [cpu pushStack:MOSAddressLow(returnAddress)];
    
    cpu.programCounter = self.address;
}

@end
