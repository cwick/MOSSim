#import "NESAddressBus.h"
#import "MOSSimpleAddressBus.h"

const int NES_RAM_SIZE = 0x800;

@interface NESAddressBus ()

@property(nonatomic) MOSSimpleAddressBus *memory;

@end

@implementation NESAddressBus

- (instancetype)init {
    self = [super init];
    if (self) {
        _memory = [MOSSimpleAddressBus new];
    }
    return self;
}

- (MOSWord)readWordFromAddress:(MOSAbsoluteAddress)address {
    MOSAbsoluteAddress decodedAddress = [self decodeAddress:address];

    return [self.memory readWordFromAddress:decodedAddress];
}

- (void)writeWord:(MOSWord)value toAddress:(MOSAbsoluteAddress)address {
    MOSAbsoluteAddress decodedAddress = [self decodeAddress:address];

    [self.memory writeWord:value toAddress:decodedAddress];
}

- (MOSAbsoluteAddress)decodeAddress:(MOSAbsoluteAddress)address {
    return address &= NES_RAM_SIZE - 1;
}


@end