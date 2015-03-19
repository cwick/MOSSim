#import <XCTest/XCTest.h>

#import "NESAddressSpace.h"
#import "MOSCPU.h"

@interface NESFakeCartridge : NSObject<MOSDevice>

@property(nonatomic) int readCount;
@property(nonatomic) int writeCount;

@end

@implementation NESFakeCartridge

- (MOSWord)readWordFromAddress:(MOSAbsoluteAddress)address {
    self.readCount++;
    return 0;
}

- (void)writeWord:(MOSWord)value toAddress:(MOSAbsoluteAddress)address {
    self.writeCount++;
}

@end

@interface NESAddressBusTests : XCTestCase

@property(nonatomic) NESAddressSpace *nes;

@end

@implementation NESAddressBusTests

- (void)setUp {
    self.nes = [NESAddressSpace new];
}

- (void)testReturnsZeroByDefault {
    for (int i=0 ; i<MOS_ADDRESS_SPACE_SIZE ; i++) {
        XCTAssertEqual([self.nes readWordFromAddress:i], 0);
    }
}

- (void)testCanWriteValuesToRAM {
    NESAddressSpace *bus = [NESAddressSpace new];
    const int PATTERN = 0xBE;

    for (int i=NES_RAM_START ; i <= NES_RAM_END ; i++) {
        [bus writeWord:PATTERN toAddress:i];
        XCTAssertEqual([bus readWordFromAddress:i], PATTERN);
    }
}

- (void)testRAMSegment0IsMirrored {
    const int PATTERN = 0xA0;

    [self writePattern:PATTERN toRAMSegment:0];
    [self assertAllRAMSegmentsMatchPattern:PATTERN];
}

- (void)testRAMSegment1IsMirrored {
    const int PATTERN = 0xA1;

    [self writePattern:PATTERN toRAMSegment:1];
    [self assertAllRAMSegmentsMatchPattern:PATTERN];
}

- (void)testRAMSegment2IsMirrored {
    const int PATTERN = 0xA2;

    [self writePattern:PATTERN toRAMSegment:2];
    [self assertAllRAMSegmentsMatchPattern:PATTERN];
}

- (void)testRAMSegment3IsMirrored {
    const int PATTERN = 0xA3;

    [self writePattern:PATTERN toRAMSegment:3];
    [self assertAllRAMSegmentsMatchPattern:PATTERN];
}

- (void)testCanReadFromCartridge {
    NESFakeCartridge *fakeCartridge = [NESFakeCartridge new];

    self.nes.cartridge = fakeCartridge;

    for (int i=NES_CARTRIDGE_START ; i <= NES_CARTRIDGE_END ; i++) {
        [self.nes readWordFromAddress:i];
    }

    XCTAssertEqual(fakeCartridge.readCount, NES_CARTRIDGE_SIZE);
}

- (void)testCanWriteToCartridge {
    const int PATTERN = 0xEB;
    NESFakeCartridge *fakeCartridge = [NESFakeCartridge new];

    self.nes.cartridge = fakeCartridge;

    for (int i=NES_CARTRIDGE_START ; i <= NES_CARTRIDGE_END ; i++) {
        [self.nes writeWord:PATTERN toAddress:i];
    }

    XCTAssertEqual(fakeCartridge.writeCount, NES_CARTRIDGE_SIZE);
}

- (void)assertAllRAMSegmentsMatchPattern:(int const)pattern {
    for (int i=0x0 ; i < NES_RAM_SIZE ; i++) {
        XCTAssertEqual([self.nes readWordFromAddress:i], pattern);
    }

    for (int i=NES_RAM_SIZE ; i < NES_RAM_SIZE*2 ; i++) {
        XCTAssertEqual([self.nes readWordFromAddress:i], pattern);
    }

    for (int i=NES_RAM_SIZE*2 ; i < NES_RAM_SIZE*3 ; i++) {
        XCTAssertEqual([self.nes readWordFromAddress:i], pattern);
    }

    for (int i=NES_RAM_SIZE*3 ; i < NES_RAM_SIZE*4 ; i++) {
        XCTAssertEqual([self.nes readWordFromAddress:i], pattern);
    }
}

- (void)writePattern:(const int) pattern toRAMSegment:(const int)segment {
    for (int i=NES_RAM_SIZE*segment ; i < NES_RAM_SIZE * (segment +1); i++) {
        [self.nes writeWord:pattern toAddress:i];
    }
}

@end
