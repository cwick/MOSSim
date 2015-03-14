#import <XCTest/XCTest.h>

#import "MOSNESAddressBus.h"
#import "MOSCPU.h"

@interface MOSNESAddressBusTests : XCTestCase

@end

@implementation MOSNESAddressBusTests

- (void)setUp {
}

- (void)testReturnsZeroByDefault {
    MOSNESAddressBus *bus = [MOSNESAddressBus new];

    for (int i=0 ; i<MOS_ADDRESS_SPACE_SIZE ; i++) {
        XCTAssertEqual([bus readWordFromAddress:i], 0);
    }
}

- (void)testCanWriteValuesToRAM {
    MOSNESAddressBus *bus = [MOSNESAddressBus new];
    const int PATTERN = 0xBE;

    for (int i=0x200 ; i <= 0x800 ; i++) {
        [bus writeWord:PATTERN toAddress:i];
        XCTAssertEqual([bus readWordFromAddress:i], PATTERN);
    }
}

@end
