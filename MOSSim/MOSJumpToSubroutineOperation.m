#import "MOSJumpToSubroutineOperation.h"
#import "MOSCPU.h"

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
    // push PCH
    // push PCL
    cpu.programCounter = self.address;
    cpu.stackPointer -= 2;
}

@end
