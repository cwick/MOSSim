#import <XCTest/XCTest.h>

#import "MOSCPU.h"
#import "MOSFakeDataStream.h"

@interface MOSProgramTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;
@property(nonatomic) MOSFakeDataStream *dataStream;

@end

@implementation MOSProgramTests

- (void)setUp {
    self.cpu = [MOSCPU new];
    self.dataStream = [MOSFakeDataStream new];
}

- (void)testSimpleInfiniteLoop {
    self.dataStream.data = @[@0x4C, @0x00, @0x00];
    [self.cpu loadProgram:self.dataStream];
    
    [self.cpu step];
    [self.cpu step];
    [self.cpu step];
    [self.cpu step];
    
    XCTAssertEqual(self.cpu.programCounter, 0x00);
}

- (void)testCountToSixteen {
    self.dataStream.data = @[
                             @0xA2, @0x00,          // Load 0x00 into X
                             @0xE8,                 // Increment X
                             @0xE0, @0x0F,          // Compare X to 0x0F
                             @0xD0, @0xFE,          // Jump -2 if Not Equal
                             @0x60,                 // return
                             ];
    
    [self.cpu loadProgram:self.dataStream];
    [self.cpu run];
}

@end
