#import "MOSNESAddressBus.h"
#import "MOSSimpleAddressBus.h"

@interface MOSNESAddressBus()

@property(nonatomic) MOSSimpleAddressBus *memory;

@end

@implementation MOSNESAddressBus

- (instancetype)init {
    self = [super init];
    if (self) {
        _memory = [MOSSimpleAddressBus new];
    }
    return self;
}

- (MOSWord)readWordFromAddress:(MOSAbsoluteAddress)address {
    return [self.memory readWordFromAddress:address];
}

- (void)writeWord:(MOSWord)value toAddress:(MOSAbsoluteAddress)address {
    [self.memory writeWord:value toAddress:address];
}

@end