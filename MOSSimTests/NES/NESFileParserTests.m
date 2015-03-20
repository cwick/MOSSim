#import <XCTest/XCTest.h>
#import "MOSTypes.h"
#import "NESFileParser.h"

@interface NESFileParserTests : XCTestCase

@end

@implementation NESFileParserTests

- (void)testParseHeader {
    const MOSWord nesFileData[] = {};
    NSData *nesFile = [NSData dataWithBytes:nesFileData length:sizeof(nesFileData)];
    NESFileParser *parser = [NESFileParser new];
    NSError *error;

    [parser parseFile:nesFile error:&error];

    XCTAssertEqualObjects(error.domain, @"NESFileParsingError");
}

@end
