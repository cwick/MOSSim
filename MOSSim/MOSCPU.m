#import "MOSCPU.h"
#import "MOSStatusRegister.h"

@implementation MOSCPU

- (instancetype)init {
    self = [super init];
    if (self) {
        _statusRegister = [MOSStatusRegister new];
    }
    
    return self;
}
@end
