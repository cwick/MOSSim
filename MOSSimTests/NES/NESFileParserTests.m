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
        0x50,
        // Flags 7
        0xA0,
        // Size of PRG RAM in 8 KB units
        0x8,
        // Flags 9
        0xFF,
        // Flags 10
        0xFF,
        // Zero filled
        0x00, 0x00, 0x00, 0x00, 0x00,

        // PRG ROM data
        0x01, 0x02, 0x03
    };

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

- (void)testParseHeader_CHR_ROM_Size {
    XCTAssertEqual(self.nesFile.chrRomSize, 2);
}

- (void)testParseHeader_PRG_RAM_Size {
    XCTAssertEqual(self.nesFile.prgRamSize, 8);
}

- (void)testParse_PRG_ROM_Data {
    char expectedDataBytes[] = { 0x01, 0x02, 0x03 };
    NSData *expectedData = [NSData dataWithBytes:expectedDataBytes length:sizeof(expectedDataBytes)];

    XCTAssertEqual([self.nesFile.prgRomData length], 3);
    XCTAssertEqualObjects(self.nesFile.prgRomData, expectedData);
}

- (void)testPlayChoice10NotSupported {
    NESFileParser *parser = [NESFileParser new];
    NSError *error;

    ((MOSWord*)self.nesFileData.mutableBytes)[7] = (MOSWord)0b0000010;

    [parser parseFile:self.nesFileData error:&error];

    XCTAssertEqualObjects(error.domain, @"NESFileParsingError");
}

- (void)testTrainerNotSupporter {
    NESFileParser *parser = [NESFileParser new];
    NSError *error;

    ((MOSWord*)self.nesFileData.mutableBytes)[6] = (MOSWord)0b0000100;

    [parser parseFile:self.nesFileData error:&error];

    XCTAssertEqualObjects(error.domain, @"NESFileParsingError");
}

- (void)testParseHeader_mapperNumber {
    NSError *error;

    self.nesFile = [self.parser parseFile:self.nesFileData error:&error];

    XCTAssertEqual(self.nesFile.mapper, 0xA5);
}

@end
