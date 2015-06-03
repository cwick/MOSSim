#import <XCTest/XCTest.h>

#import "NESAddressSpace.h"
#import "MOSCPU.h"
#import "NESNROMCartridge.h"

@interface NESNROMCartridgeTest : XCTestCase

@property(nonatomic) NESNROMCartridge *cartridge;

@end

@implementation NESNROMCartridgeTest

static MOSWord rom0[] = { 1, 2, 3, 4, 5 };
static MOSWord rom1[] = { 6, 7, 8 };

- (void)setUp {
    self.cartridge = [NESNROMCartridge new];
}

- (void)testReturnsZeroIfNoROMBanksInstalled {
    XCTAssertEqual([self.cartridge readWordFromAddress:0x1234], 0);
}

- (void)testLoadsROM0AtAddress0x8000 {
    self.cartridge.romBank0 = [NSData dataWithBytes:rom0 length:sizeof(rom0)];

    for (int i=0 ; i<sizeof(rom0) ; i++) {
        XCTAssertEqual(rom0[i], [self.cartridge readWordFromAddress:0x8000+i]);
    }
}

- (void)testROM0IsMirroredAt0xC000 {
    self.cartridge.romBank0 = [NSData dataWithBytes:rom0 length:sizeof(rom0)];

    for (int i=0 ; i<sizeof(rom0) ; i++) {
        XCTAssertEqual(rom0[i], [self.cartridge readWordFromAddress:0xC000+i]);
    }
}

- (void)testLoadsROM1AtAddress0xC000 {
    self.cartridge.romBank1 = [NSData dataWithBytes:rom1 length:sizeof(rom1)];
    
    for (int i=0 ; i<sizeof(rom1) ; i++) {
        XCTAssertEqual(rom1[i], [self.cartridge readWordFromAddress:0xC000+i]);
    }
}

- (void)testROM1IsMirroredAt0x8000 {
    self.cartridge.romBank1 = [NSData dataWithBytes:rom1 length:sizeof(rom1)];

    for (int i=0 ; i<sizeof(rom1) ; i++) {
        XCTAssertEqual(rom1[i], [self.cartridge readWordFromAddress:0x8000+i]);
    }
}

- (void)testDataIsReadFromBothROMBanks {
    self.cartridge.romBank0 = [NSData dataWithBytes:rom0 length:sizeof(rom0)];
    self.cartridge.romBank1 = [NSData dataWithBytes:rom1 length:sizeof(rom1)];

    for (int i=0 ; i<sizeof(rom0) ; i++) {
        XCTAssertEqual(rom0[i], [self.cartridge readWordFromAddress:0x8000+i]);
    }

    for (int i=0 ; i<sizeof(rom1) ; i++) {
        XCTAssertEqual(rom1[i], [self.cartridge readWordFromAddress:0xC000+i]);
    }
}

@end
