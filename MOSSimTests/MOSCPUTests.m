#import <XCTest/XCTest.h>

#import "MOSCPU.h"

@interface MOSCPUTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;
@property(nonatomic) NSData *programData;

@end

@implementation MOSCPUTests

#define LOAD_PROGRAM(...) MOSWord programData[] = {__VA_ARGS__}; \
    [self loadProgram:programData size:sizeof(programData)]

- (void)setUp {
    self.cpu = [MOSCPU new];
}

- (void)testProgramCounterIsIncrementedByOne {
    LOAD_PROGRAM(MOSOPCodeCLC);
    
    [self.cpu step];
    XCTAssertEqual(self.cpu.programCounter, 1);
}

- (void)testProgramCounterIsIncrementedByTwo {
    LOAD_PROGRAM(MOSOPCodeLDXImmediate, 0xFF);
    
    [self.cpu step];
    XCTAssertEqual(self.cpu.programCounter, 2);
}

- (void)testSimpleInfiniteLoop {
    LOAD_PROGRAM(MOSOPCodeJMP, 0x00, 0x00);
    
    [self.cpu step];
    [self.cpu step];
    [self.cpu step];
    [self.cpu step];
    
    XCTAssertEqual(self.cpu.programCounter, 0x00);
}

//- (void)testCountToSixteen {
//    self.dataStream.data = @[
//                             @0xA2, @0x00,          // Load 0x00 into X
//                             @0xE8,                 // Increment X
//                             @0xE0, @0x0F,          // Compare X to 0x0F
//                             @0xD0, @0xFE,          // Jump -2 if Not Equal
//                             @0x60,                 // return
//                             ];
//    
//    [self.cpu loadProgram:self.dataStream];
//    [self.cpu run];
//}

- (void)loadProgram:(const MOSWord *)programData size:(NSUInteger)length {
    NSData *program = [NSData dataWithBytes:programData length:length];
    [self.cpu loadProgram:program];
}

@end
