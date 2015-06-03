#import "NESFile.h"
#import "NESTestFile.h"
#import <XCTest/XCTest.h>
#import "NESFileParser.h"
#import "NESNROMCartridge.h"
#import "NESAddressSpace.h"
#import "MOSCPU.h"

@interface NESBasicProgramTest : XCTestCase

@end

@implementation NESBasicProgramTest

- (void)setUp {
    NSError *error;
    NSData *nesFileData = [NSData dataWithBytes:NESTestFile length:NESTestFileLength];
    NESFileParser *parser = [NESFileParser new];
    NESFile *nesFile = [parser parseFile:nesFileData error:&error];

    XCTAssertNil(error);
    XCTAssertEqual(nesFile.prgRomData.count, 2);
    XCTAssertEqual(nesFile.chrRomSize, 1);
    XCTAssertEqual(nesFile.mapper, 0);

    id rom0, rom1;
    if (nesFile.prgRomData.count > 0) {
        rom0 = nesFile.prgRomData[0];
    }
    if (nesFile.prgRomData.count > 1) {
        rom1 = nesFile.prgRomData[1];
    }

    NESNROMCartridge *cartridge = [NESNROMCartridge cartridgeWithRomBank0:rom0 andRomBank1:rom1];
    NESAddressSpace *nes = [NESAddressSpace new];
    nes.cartridge = cartridge;

    MOSCPU *cpu = [MOSCPU new];

}

@end
