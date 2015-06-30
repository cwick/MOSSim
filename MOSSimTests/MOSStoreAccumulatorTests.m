#import <XCTest/XCTest.h>
#import "MOSStoreAccumulatorOperation.h"
#import "MOSCPU.h"
#import "MOSInstruction.h"

@interface MOSStoreAccumulatorTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;

@end

@implementation MOSStoreAccumulatorTests

- (void)setUp {
    self.cpu = [MOSCPU new];
}

- (MOSOperation *)createOperationWithOperand:(MOSOperand)operand addressingMode:(MOSAddressingMode)mode {
    MOSInstruction *instruction = [[MOSInstruction alloc] initWithOperand:operand addressingMode:mode];
    MOSOperation *operation = [[MOSStoreAccumulatorOperation alloc] initWithInstruction:instruction];
    return operation;
}

- (void)testStoreZeroPage {
    MOSOperation *op = [self createOperationWithOperand:0x10 addressingMode:MOSAddressingModeZeroPage];
    self.cpu.registerValues.a = 0x12;
    [op execute:self.cpu];

    XCTAssertEqual([self.cpu readWordFromAddress:0x10], self.cpu.registerValues.a);
}

- (void)testStoreIndirectIndexed {
    MOSOperation *op = [self createOperationWithOperand:0x10 addressingMode:MOSAddressingModeIndirectIndexed];
    [self.cpu writeWord:0xEF toAddress:0x10];
    [self.cpu writeWord:0xBE toAddress:0x11];
    self.cpu.registerValues.y = 0x05;
    self.cpu.registerValues.a = 0xFE;

    [op execute:self.cpu];

    XCTAssertEqual([self.cpu readWordFromAddress:0xBEEF + self.cpu.registerValues.y], self.cpu.registerValues.a);
}

- (void)testStoreAbsoluteIndexedX {
    MOSOperation *op = [self createOperationWithOperand:0x1234 addressingMode:MOSAddressingModeAbsoluteIndexedX];
    self.cpu.registerValues.x = 0x01;
    self.cpu.registerValues.a = 0xDE;

    [op execute:self.cpu];

    XCTAssertEqual([self.cpu readWordFromAddress:0x1234 + self.cpu.registerValues.x], self.cpu.registerValues.a);
}

@end
