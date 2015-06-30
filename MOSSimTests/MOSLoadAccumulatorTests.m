#import <XCTest/XCTest.h>
#import "MOSLoadAccumulatorOperation.h"
#import "MOSCPU.h"
#import "MOSInstruction.h"

@interface MOSLoadAccumulatorTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;

@end

@implementation MOSLoadAccumulatorTests

- (void)setUp {
    self.cpu = [MOSCPU new];
}

- (MOSOperation *)createOperationWithOperand:(MOSOperand)operand addressingMode:(MOSAddressingMode)mode {
    MOSInstruction *instruction = [[MOSInstruction alloc] initWithOperand:operand addressingMode:mode];
    MOSOperation *operation = [[MOSLoadAccumulatorOperation alloc] initWithInstruction:instruction];
    return operation;
}

- (void)testLoadImmediate {
    MOSOperation *op = [self createOperationWithOperand:123 addressingMode:MOSAddressingModeImmediate];
    [op execute:self.cpu];
    XCTAssertEqual(self.cpu.registerValues.a, 123);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, NO);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, NO);
}

- (void)testLoadImmediateZero {
    MOSOperation *op = [self createOperationWithOperand:0 addressingMode:MOSAddressingModeImmediate];
    [op execute:self.cpu];
    XCTAssertEqual(self.cpu.registerValues.a, 0);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, YES);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, NO);
}

- (void)testLoadImmediateNegative {
    MOSOperation *op = [self createOperationWithOperand:-12 addressingMode:MOSAddressingModeImmediate];
    [op execute:self.cpu];
    XCTAssertEqual((MOSSignedRegisterValue)self.cpu.registerValues.a, -12);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, NO);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, YES);
}

- (void)testLoadZeroPage {
    MOSOperation *op = [self createOperationWithOperand:0x10 addressingMode:MOSAddressingModeZeroPage];
    [self.cpu writeWord:0xFF toAddress:0x10];
    [op execute:self.cpu];

    XCTAssertEqual(self.cpu.registerValues.a, 0xFF);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, NO);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, YES);
}

- (void)testLoadIndirectIndexed {
    MOSOperation *op = [self createOperationWithOperand:0x10 addressingMode:MOSAddressingModeIndirectIndexed];
    [self.cpu writeWord:0xEF toAddress:0x10];
    [self.cpu writeWord:0xBE toAddress:0x11];
    [self.cpu writeWord:0xDF toAddress:0xBEEF+0x05];
    self.cpu.registerValues.y = 0x05;
    [op execute:self.cpu];

    XCTAssertEqual(self.cpu.registerValues.a, 0xDF);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, NO);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, YES);
}

- (void)testLoadAbsolute {
    MOSOperation *op = [self createOperationWithOperand:0x1234 addressingMode:MOSAddressingModeAbsolute];
    [self.cpu writeWord:0x10 toAddress:0x1234];
    [op execute:self.cpu];

    XCTAssertEqual(self.cpu.registerValues.a, 0x10);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, NO);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, NO);
}
@end
