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

- (void)testMemoryIsZeroedOut {
    XCTAssertEqual([self.cpu readWord:123], 0);
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

- (void)testCPUHaltsForceBreak {
    LOAD_PROGRAM(MOSOPCodeBRK);
    
    [self.cpu run];
    XCTAssertEqual(self.cpu.programCounter, 1);
}

- (void)testPopStack {
    [self.cpu pushStack:12];
    [self.cpu pushStack:34];
    
    XCTAssertEqual([self.cpu popStack], 34);
    XCTAssertEqual([self.cpu popStack], 12);
}

- (void)testSimpleInfiniteLoop {
    LOAD_PROGRAM(MOSOPCodeJMP, 0x00, 0x00);
    
    [self.cpu step];
    [self.cpu step];
    [self.cpu step];
    [self.cpu step];
    
    XCTAssertEqual(self.cpu.programCounter, 0x00);
}

- (void)testCountToSixteen {
    LOAD_PROGRAM(
        MOSOPCodeLDXImmediate, 0x00, // Load 0x00 into X
        MOSOPCodeINX,                // Increment X
        MOSOPCodeCPXImmediate, 16, // Compare X to 16
        MOSOPCodeBNE, -5,          // Jump -2 if Not Equal
        MOSOPCodeBRK,                // return
        );
    
    [self.cpu run];
    XCTAssertEqual(self.cpu.registerValues.x, 16);
}

- (void)loadProgram:(const MOSWord *)programData size:(NSUInteger)length {
    NSData *program = [NSData dataWithBytes:programData length:length];
    [self.cpu loadProgram:program];
}

@end
