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
    if (address >= NES_RAM_SIZE*3) {
        address -= NES_RAM_SIZE;
    }

    if (address >= NES_RAM_SIZE*2) {
        address -= NES_RAM_SIZE;
    }

    if (address >= NES_RAM_SIZE) {
        address -= NES_RAM_SIZE;
    }

    return [self.memory readWordFromAddress:address];
}

- (void)writeWord:(MOSWord)value toAddress:(MOSAbsoluteAddress)address {
    if (address >= NES_RAM_SIZE*3) {
        address -= NES_RAM_SIZE;
    }

    if (address >= NES_RAM_SIZE*2) {
        address -= NES_RAM_SIZE;
    }

    if (address >= NES_RAM_SIZE) {
        address -= NES_RAM_SIZE;
    }

    [self.memory writeWord:value toAddress:address];
}

@end