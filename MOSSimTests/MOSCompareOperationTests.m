#import <XCTest/XCTest.h>

#import "MOSCPU.h"
#import "MOSCompareOperation.h"
#import "MOSInstructionDecoder.h"
#import "MOSCompareYOperation.h"
#import "MOSCompareXOperation.h"
#import "MOSInstruction.h"

@interface MOSCompareOperationTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;

@end

@implementation MOSCompareOperationTests

- (void)setUp {
    self.cpu = [MOSCPU new];
}

- (MOSOperation *)createOperationWithImmediateValue:(MOSImmediateValue)value register:(NSString *)reg {
    MOSInstruction *instruction = [[MOSInstruction alloc] initWithOperand:value addressingMode:MOSAddressingModeImmediate];
    if ([reg isEqualToString:@"x"]) {
        return [[MOSCompareXOperation alloc] initWithInstruction:instruction];
    } else {
        return [[MOSCompareYOperation alloc] initWithInstruction:instruction];
    }
}

- (void)testCompareXEqualImmediate {
    MOSOperation *operation = [self createOperationWithImmediateValue:0xFF register:@"x"];

    self.cpu.registerValues.x = 0xFF;
    [operation execute:self.cpu];
    
    XCTAssertTrue(self.cpu.statusRegister.zeroFlag);
    XCTAssertFalse(self.cpu.statusRegister.negativeFlag);
    XCTAssertTrue(self.cpu.statusRegister.carryFlag);
}

- (void)testCompareYEqualImmediate {
    MOSOperation *operation = [self createOperationWithImmediateValue:0xFF register:@"y"];

    self.cpu.registerValues.y = 0xFF;
    [operation execute:self.cpu];

    XCTAssertTrue(self.cpu.statusRegister.zeroFlag);
    XCTAssertFalse(self.cpu.statusRegister.negativeFlag);
    XCTAssertTrue(self.cpu.statusRegister.carryFlag);
}

- (void)testCompareXNotEqualImmediate {
    MOSOperation *operation = [self createOperationWithImmediateValue:0x20 register:@"x"];

    self.cpu.registerValues.x = 0x00;
    [operation execute:self.cpu];
    
    XCTAssertFalse(self.cpu.statusRegister.zeroFlag);
    XCTAssertTrue(self.cpu.statusRegister.negativeFlag);
    XCTAssertFalse(self.cpu.statusRegister.carryFlag);
}

@end
