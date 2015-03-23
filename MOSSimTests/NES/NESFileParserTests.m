#import "NESFile.h"
#import <XCTest/XCTest.h>
#import "NESFileParser.h"

@interface NESFileParserTests : XCTestCase

@property(nonatomic, strong) NSMutableData *nesFileData;
@property(nonatomic, strong) NESFileParser *parser;
@property(nonatomic, strong) NESFile *nesFile;
@end

@implementation NESFileParserTests

- (void)setUp {
    const MOSWord nesFileData[] = {
        // NES
        0x4E, 0x45, 0x53, 0x1A,
        // PRG ROM Size
        0x9,
        // CHR ROM Size
        0x2,
        // Flags 6
        0x0,
        // Flags 7
        0x0 };

    NSError *error;
    self.nesFileData = [NSMutableData dataWithBytes:nesFileData length:sizeof(nesFileData)];
    self.parser = [NESFileParser new];
    self.nesFile = [self.parser parseFile:self.nesFileData error:&error];

    XCTAssertNil(error);
}

- (void)testParseEmptyFile {
    const MOSWord nesFileData[] = {};
    NSData *nesFile = [NSData dataWithBytes:nesFileData length:sizeof(nesFileData)];
    NESFileParser *parser = [NESFileParser new];
    NSError *error;

    [parser parseFile:nesFile error:&error];

    XCTAssertEqualObjects(error.domain, @"NESFileParsingError");
}

- (void)testParseHeader_PRG_ROM_Size {
    XCTAssertEqual(self.nesFile.prgRomSize, 9);
}

- (void)testParseHeader_CHR_ROM_Size {
    XCTAssertEqual(self.nesFile.chrRomSize, 2);
}

- (void)testParseHeader_mapperNumber {
    NSError *error;

    // Set Flags 6
    ((MOSWord*)self.nesFileData.mutableBytes)[6] = 0x50;

    // Set Flags 7
    ((MOSWord*)self.nesFileData.mutableBytes)[7] = 0xA0;

    self.nesFile = [self.parser parseFile:self.nesFileData error:&error];

    XCTAssertEqual(self.nesFile.mapper, 0xA5);
}

@end