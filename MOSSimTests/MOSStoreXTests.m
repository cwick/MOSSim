#import <XCTest/XCTest.h>

#import "MOSStoreRegisterXOperation.h"
#import "MOSCPU.h"
#import "MOSInstructionDecoder.h"

@interface MOSStoreXTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;

@end

@implementation MOSStoreXTests

- (void)setUp {
    self.cpu = [MOSCPU new];
}

- (MOSOperation *)createOperationWithOperand:(MOSOperand)operand addressingMode:(MOSAddressingMode)mode {
    MOSInstruction *instruction = [[MOSInstruction alloc] initWithOperand:operand addressingMode:mode];
    MOSOperation *operation = [[MOSStoreRegisterXOperation alloc] initWithInstruction:instruction];
    return operation;
}

- (void)testStoreZeroPage {
    MOSOperation *op = [self createOperationWithOperand:0x10 addressingMode:MOSAddressingModeZeroPage];
    self.cpu.registerValues.x = 0x12;
    [op execute:self.cpu];

    XCTAssertEqual([self.cpu readWordFromAddress:0x10], self.cpu.registerValues.x);
}

@end
