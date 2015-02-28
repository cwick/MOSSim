#import "MOSCPU.h"
#import "MOSStatusRegister.h"

@implementation MOSCPU

- (instancetype)init {
    self = [super init];
    if (self) {
        _statusRegister = [MOSStatusRegister new];
        _registerValues = [MOSRegisterValues new];
    }
    
    return self;
}

- (void)loadProgram:(id<MOSDataStream>)data {

}

- (void)step {
    
}

@end
