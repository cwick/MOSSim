#import "NESFile.h"
#import "NESTestFile.h"
#import <XCTest/XCTest.h>
#import "NESFileParser.h"
#import "NESNROMCartridge.h"
#import "NESAddressSpace.h"
#import "MOSCPU.h"
#import "MOSUtils.h"

@interface NESBasicProgramTest : XCTestCase

@property(nonatomic) NESAddressSpace *addressSpace;
@property(nonatomic) NESNROMCartridge *cartridge;
@end

@implementation NESBasicProgramTest

- (void)setUp {
    // TODO: put all this setup into a NESEmulator class
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

    self.cartridge = [NESNROMCartridge cartridgeWithRomBank0:rom0 andRomBank1:rom1];
    self.addressSpace = [NESAddressSpace new];
    self.addressSpace.cartridge = self.cartridge;

}

- (void)testCanRunProgram {
    MOSCPU *cpu = [MOSCPU new];
    cpu.dataBus = self.addressSpace;
    cpu.programCounter = MOSAbsoluteAddressMake([self.cartridge readWordFromAddress:0xFFFC], [self.cartridge readWordFromAddress:0xFFFD]);

    [cpu run];
}

@end
