//
// Created by Carmen Wick on 6/2/15.
// Copyright (c) 2015 Carmen Wick. All rights reserved.
//

#import "NESNROMCartridge.h"

static const int BANK0_START = 0x8000;
static const int BANK1_START = 0xC000;

@implementation NESNROMCartridge

+ (NESNROMCartridge *)cartridgeWithRomBank0:(NSData *)bank0 andRomBank1:(NSData *)bank1 {
    NESNROMCartridge *cartridge = [NESNROMCartridge new];
    cartridge.romBank0 = bank0;
    cartridge.romBank1 = bank1;
    return cartridge;
}

- (MOSWord)readWordFromAddress:(MOSAbsoluteAddress)address {
    NSData *romBank0 = self.romBank0;
    NSData *romBank1 = self.romBank1;

    if (romBank0 == nil) {
        romBank0 = romBank1;
    }
    if (romBank1 == nil) {
        romBank1 = romBank0;
    }

    return [self readWordFromBank0:romBank0 orBank1:romBank1 atAddress:address];
}

- (MOSWord)readWordFromBank0:(NSData *)romBank0 orBank1:(NSData *)romBank1 atAddress:(MOSAbsoluteAddress)address {
    if (romBank0 == nil && romBank1 == nil) {
        return 0;
    }

    if (address < BANK1_START) {
        return [self readWordFromBank:romBank0 atAddress:(MOSAbsoluteAddress) (address - BANK0_START)];
    } else {
        return [self readWordFromBank:romBank1 atAddress:(MOSAbsoluteAddress) (address - BANK1_START)];
    }
}

- (MOSWord)readWordFromBank:(NSData *)data atAddress:(MOSAbsoluteAddress)address {
    return ((MOSWord*)data.bytes)[address];
}

- (void)writeWord:(MOSWord)value toAddress:(MOSAbsoluteAddress)address {

}


@end