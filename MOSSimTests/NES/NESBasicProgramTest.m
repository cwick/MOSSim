#import "NESFile.h"
#import "NESTestFile.h"
#import <XCTest/XCTest.h>
#import "NESFileParser.h"

@interface NESBasicProgramTest : XCTestCase

@property(nonatomic, strong) NSData *nesFileData;
@property(nonatomic, strong) NESFileParser *parser;
@property(nonatomic, strong) NESFile *nesFile;
@end

@implementation NESBasicProgramTest

- (void)setUp {
    NSError *error;
    self.nesFileData = [NSData dataWithBytes:NESTestFile length:NESTestFileLength];
    self.parser = [NESFileParser new];
    self.nesFile = [self.parser parseFile:self.nesFileData error:&error];

    XCTAssertNil(error);
}

- (void)testStuff {
    NESFileParser *parser = [NESFileParser new];
    NSError *error;

    NESFile *file = [parser parseFile:self.nesFileData error:&error];
    XCTAssertNil(error);

    NSLog(@"%d", file.chrRomSize);
    NSLog(@"%d", file.mapper);
}

@end
