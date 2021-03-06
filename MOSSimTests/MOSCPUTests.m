#import <XCTest/XCTest.h>

#import "MOSCPU.h"
#import "MOSUtils.h"
#import "MOSReadWriteMemory.h"

@interface MOSCPUTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;
@property(nonatomic) MOSReadWriteMemory *memory;

@end

@implementation MOSCPUTests

#define LOAD_PROGRAM(...) MOSWord programData[] = {__VA_ARGS__}; \
    [self loadProgram:programData size:sizeof(programData)]

- (void)setUp {
    self.cpu = [MOSCPU new];
    self.memory = [MOSReadWriteMemory new];
    self.cpu.dataBus = self.memory;
}

- (void)testMemoryIsZeroedOut {
    XCTAssertEqual([self.cpu readWordFromAddress:123], 0);
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

- (void)testStackIsLocatedAtPageOne {
    self.cpu.stackPointer = 0xFF;
    [self.cpu pushStack:0xBE];
    
    MOSAbsoluteAddress expectedAddress = MOSAbsoluteAddressMake(0xFF, 0x01);
    XCTAssertEqual([self.cpu readWordFromAddress:expectedAddress], 0xBE);
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
        MOSOPCodeBNE, -5,          // Jump -5 if Not Equal
        MOSOPCodeBRK,                // return
        );
    
    [self.cpu run];
    XCTAssertEqual(self.cpu.registerValues.x, 16);
}

- (void)testSubroutine {
    LOAD_PROGRAM(
        // Initialize
        MOSOPCodeLDXImmediate, 0xFF,
        MOSOPCodeTXS,
        MOSOPCodeJMP, 0x09, 0x00,
                 
        // Subroutine
        MOSOPCodeLDXImmediate, 0xBE,
        MOSOPCodeRTS,
                 
        // Main
        MOSOPCodeJSR, 0x06, 0x00,
        MOSOPCodeBRK,
        );
    
    [self.cpu run];
    XCTAssertEqual(self.cpu.registerValues.x, 0xBE);
}

- (void)testClearMemory {
    const MOSWord CLEAR_PATTERN = 0xFF;
    const MOSWord SIZE = 0xDE;
    const MOSAbsoluteAddress ADDRESS = 0xBEEF;

    LOAD_PROGRAM(
        MOSOPCodeLDAImmediate, CLEAR_PATTERN,
        MOSOPCodeLDYImmediate, SIZE,
        MOSOPCodeLDXImmediate, MOSAddressLow(ADDRESS),
        MOSOPCodeSTXZeroPage,  0x00,
        MOSOPCodeLDXImmediate, MOSAddressHigh(ADDRESS),
        MOSOPCodeSTXZeroPage,  0x01,
        MOSOPCodeDEY,
        MOSOPCodeSTAIndirectIndexed, 0x00,
        MOSOPCodeBNE, -5,
        MOSOPCodeBRK,
    );

    [self.cpu run];

    for (MOSWord i=0 ; i<SIZE ; i++) {
        XCTAssertEqual([self.cpu readWordFromAddress:ADDRESS+i], CLEAR_PATTERN);
    }
}

- (void)loadProgram:(const MOSWord *)programData size:(NSUInteger)length {
    NSData *program = [NSData dataWithBytes:programData length:length];
    [self.memory loadBinaryImage:program];
}

@end
