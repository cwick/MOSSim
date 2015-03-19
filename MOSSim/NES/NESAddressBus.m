#import "NESAddressBus.h"
#import "MOSSimpleAddressBus.h"
#import "NESCartridge.h"

const int NES_RAM_START = 0x0;
const int NES_RAM_END = 0x7FF;
const int NES_RAM_SIZE = NES_RAM_END - NES_RAM_START + 1;
const int NES_CARTRIDGE_START = 0x4020;
const int NES_CARTRIDGE_END = 0xFFFF;
const int NES_CARTRIDGE_SIZE = NES_CARTRIDGE_END - NES_CARTRIDGE_START + 1;

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
    if (address >= NES_CARTRIDGE_START) {
        return [self readWordFromCartridge:address];
    } else {
        return [self readWordFromRAM:address];
    }
}

- (MOSWord)readWordFromRAM:(MOSAbsoluteAddress)address {
    MOSAbsoluteAddress decodedAddress = [self decodeRAMAddress:address];

    return [self.memory readWordFromAddress:decodedAddress];
}

- (MOSWord)readWordFromCartridge:(MOSAbsoluteAddress)address {
    return [self.cartridge readWordFromAddress:address];
}

- (void)writeWord:(MOSWord)value toAddress:(MOSAbsoluteAddress)address {
    if (address >= NES_CARTRIDGE_START) {
        [self writeWord:value toCartridgeAddress:address];
    } else {
        [self writeWord:value toRAMAddress:address];
    }
}

- (void)writeWord:(MOSWord)value toRAMAddress:(MOSAbsoluteAddress)address {
    MOSAbsoluteAddress decodedAddress = [self decodeRAMAddress:address];

    [self.memory writeWord:value toAddress:decodedAddress];
}

- (void)writeWord:(MOSWord)value toCartridgeAddress:(MOSAbsoluteAddress)address {
    [self.cartridge writeWord:value toAddress:address];
}

- (MOSAbsoluteAddress)decodeRAMAddress:(MOSAbsoluteAddress)address {
    return address &= NES_RAM_SIZE - 1;
}

@end