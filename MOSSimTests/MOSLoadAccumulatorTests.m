#import <XCTest/XCTest.h>
#import "MOSLoadAccumulatorOperation.h"
#import "MOSCPU.h"
#import "MOSOperation.h"

@interface MOSLoadAccumulatorTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;

@end

@implementation MOSLoadAccumulatorTests

- (void)setUp {
    self.cpu = [MOSCPU new];
}

- (void)testLoadImmediate {
    MOSOperation *op = [[MOSLoadAccumulatorOperation alloc] initWithOperand:123 addressingMode:MOSAddressingModeImmediate];
    [op execute:self.cpu];
    XCTAssertEqual(self.cpu.registerValues.a, 123);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, NO);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, NO);
}

- (void)testLoadImmediateZero {
    MOSOperation *op = [[MOSLoadAccumulatorOperation alloc] initWithOperand:0 addressingMode:MOSAddressingModeImmediate];
    [op execute:self.cpu];
    XCTAssertEqual(self.cpu.registerValues.a, 0);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, YES);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, NO);
}

- (void)testLoadImmediateNegative {
    MOSOperation *op = [[MOSLoadAccumulatorOperation alloc] initWithOperand:-12 addressingMode:MOSAddressingModeImmediate];
    [op execute:self.cpu];
    XCTAssertEqual((MOSSignedRegisterValue)self.cpu.registerValues.a, -12);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, NO);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, YES);
}

- (void)testLoadZeroPage {
    MOSOperation *op = [[MOSLoadAccumulatorOperation alloc] initWithOperand:0x10 addressingMode:MOSAddressingModeZeroPage];
    [self.cpu writeWord:0xFF toAddress:0x10];
    [op execute:self.cpu];

    XCTAssertEqual(self.cpu.registerValues.a, 0xFF);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, NO);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, YES);
}

- (void)testLoadIndirectIndexed {
    MOSOperation *op = [[MOSLoadAccumulatorOperation alloc] initWithOperand:0x10 addressingMode:MOSAddressingModeIndirectIndexed];
    [self.cpu writeWord:0xEF toAddress:0x10];
    [self.cpu writeWord:0xBE toAddress:0x11];
    [self.cpu writeWord:0xDF toAddress:0xBEEF+0x05];
    self.cpu.registerValues.y = 0x05;
    [op execute:self.cpu];

    XCTAssertEqual(self.cpu.registerValues.a, 0xDF);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, NO);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, YES);
}

@end
