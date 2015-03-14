#import <XCTest/XCTest.h>

#import "NESAddressBus.h"
#import "MOSCPU.h"

@interface NESAddressBusTests : XCTestCase

@property(nonatomic) NESAddressBus *bus;

@end

@implementation NESAddressBusTests

- (void)setUp {
    self.bus = [NESAddressBus new];
}

- (void)testReturnsZeroByDefault {
    for (int i=0 ; i<MOS_ADDRESS_SPACE_SIZE ; i++) {
        XCTAssertEqual([self.bus readWordFromAddress:i], 0);
    }
}

- (void)testCanWriteValuesToRAM {
    NESAddressBus *bus = [NESAddressBus new];
    const int PATTERN = 0xBE;

    for (int i=0x0 ; i < NES_RAM_SIZE ; i++) {
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

- (void)assertAllRAMSegmentsMatchPattern:(int const)pattern {
    for (int i=0x0 ; i < NES_RAM_SIZE ; i++) {
        XCTAssertEqual([self.bus readWordFromAddress:i], pattern);
    }

    for (int i=NES_RAM_SIZE ; i < NES_RAM_SIZE*2 ; i++) {
        XCTAssertEqual([self.bus readWordFromAddress:i], pattern);
    }

    for (int i=NES_RAM_SIZE*2 ; i < NES_RAM_SIZE*3 ; i++) {
        XCTAssertEqual([self.bus readWordFromAddress:i], pattern);
    }

    for (int i=NES_RAM_SIZE*3 ; i < NES_RAM_SIZE*4 ; i++) {
        XCTAssertEqual([self.bus readWordFromAddress:i], pattern);
    }
}

- (void)writePattern:(const int) pattern toRAMSegment:(const int)segment {
    for (int i=NES_RAM_SIZE*segment ; i < NES_RAM_SIZE * (segment +1); i++) {
        [self.bus writeWord:pattern toAddress:i];
    }
}

@end
