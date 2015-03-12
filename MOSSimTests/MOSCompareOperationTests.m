#import <XCTest/XCTest.h>

#import "MOSCPU.h"
#import "MOSCompareOperation.h"
#import "MOSInstructionDecoder.h"

@interface MOSCompareOperationTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;

@end

@implementation MOSCompareOperationTests

- (void)setUp {
    self.cpu = [MOSCPU new];
}

- (MOSOperation *)createOperationWithImmediateValue:(MOSImmediateValue)value {
    MOSInstruction *instruction = [[MOSInstruction alloc] initWithOperand:value addressingMode:MOSAddressingModeImmediate];
    MOSOperation *operation = [[MOSCompareOperation alloc] initWithInstruction:instruction];
    return operation;
}

- (void)testCompareXEqualImmediate {
    MOSOperation *operation = [self createOperationWithImmediateValue:0xFF];

    self.cpu.registerValues.x = 0xFF;
    [operation execute:self.cpu];
    
    XCTAssertTrue(self.cpu.statusRegister.zeroFlag);
    XCTAssertFalse(self.cpu.statusRegister.negativeFlag);
    XCTAssertTrue(self.cpu.statusRegister.carryFlag);
    
}

- (void)testCompareXNotEqualImmediate {
    MOSOperation *operation = [self createOperationWithImmediateValue:0x20];

    self.cpu.registerValues.x = 0x00;
    [operation execute:self.cpu];
    
    XCTAssertFalse(self.cpu.statusRegister.zeroFlag);
    XCTAssertTrue(self.cpu.statusRegister.negativeFlag);
    XCTAssertFalse(self.cpu.statusRegister.carryFlag);
}

@end
