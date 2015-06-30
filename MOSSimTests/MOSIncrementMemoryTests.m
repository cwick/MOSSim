#import <XCTest/XCTest.h>

#import "MOSCPU.h"
#import "MOSIncrementRegisterOperation.h"
#import "MOSIncrementMemoryOperation.h"
#import "MOSInstruction.h"

@interface MOSIncrementMemoryTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;
@property(nonatomic) MOSIncrementMemoryOperation *operation;

@end

@implementation MOSIncrementMemoryTests

- (MOSOperation *)createOperationWithOperand:(MOSOperand)operand addressingMode:(MOSAddressingMode)mode {
    MOSInstruction *instruction = [[MOSInstruction alloc] initWithOperand:operand addressingMode:mode];
    MOSOperation *operation = [[MOSIncrementMemoryOperation alloc] initWithInstruction:instruction];
    return operation;
}

- (void)setUp {
    self.cpu = [MOSCPU new];
}

- (void)testIncrementZeroPage {
    [self.cpu writeWord:0x0 toAddress:0x5];
    MOSOperation *operation = [self createOperationWithOperand:0x5 addressingMode:MOSAddressingModeZeroPage];
    [operation execute:self.cpu];

    XCTAssertEqual([self.cpu readWordFromAddress:0x5], 0x1);
    XCTAssertFalse(self.cpu.statusRegister.zeroFlag);
    XCTAssertFalse(self.cpu.statusRegister.negativeFlag);
}

- (void)testIncrementZeroPageWithOverflow {
    [self.cpu writeWord:0xFF toAddress:0x5];
    MOSOperation *operation = [self createOperationWithOperand:0x5 addressingMode:MOSAddressingModeZeroPage];
    [operation execute:self.cpu];

    XCTAssertEqual([self.cpu readWordFromAddress:0x5], 0x00);
    XCTAssertTrue(self.cpu.statusRegister.zeroFlag);
    XCTAssertFalse(self.cpu.statusRegister.negativeFlag);
}

- (void)testIncrementZeroPageWithNegative {
    [self.cpu writeWord:0xF0 toAddress:0x5];
    MOSOperation *operation = [self createOperationWithOperand:0x5 addressingMode:MOSAddressingModeZeroPage];
    [operation execute:self.cpu];

    XCTAssertEqual([self.cpu readWordFromAddress:0x5], 0xF1);
    XCTAssertFalse(self.cpu.statusRegister.zeroFlag);
    XCTAssertTrue(self.cpu.statusRegister.negativeFlag);
}

@end
