#import <XCTest/XCTest.h>
#import "MOSTypes.h"
#import "NESFileParser.h"

@interface NESFileParserTests : XCTestCase

@end

@implementation NESFileParserTests

- (void)testParseEmptyFile {
    const MOSWord nesFileData[] = {};
    NSData *nesFile = [NSData dataWithBytes:nesFileData length:sizeof(nesFileData)];
    NESFileParser *parser = [NESFileParser new];
    NSError *error;

    [parser parseFile:nesFile error:&error];

    XCTAssertEqualObjects(error.domain, @"NESFileParsingError");
}

- (void)testParseHeader {
    const MOSWord nesFileData[] = { 0x4E, 0x45, 0x53, 0x1A };
    NSData *nesFile = [NSData dataWithBytes:nesFileData length:sizeof(nesFileData)];
    NESFileParser *parser = [NESFileParser new];
    NSError *error;

    [parser parseFile:nesFile error:&error];

    XCTAssertNil(error);
}

@end
