#import <XCTest/XCTest.h>

#import "MOSCPU.h"
#import "MOSLoadRegisterXOperation.h"
#import "MOSLoadRegisterYOperation.h"
#import "MOSInstruction.h"

@interface MOSLoadRegisterTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;

@end

@implementation MOSLoadRegisterTests

- (void)setUp {
    self.cpu = [MOSCPU new];
}

- (MOSOperation *)createOperation:(Class)klass withImmediateValue:(MOSImmediateValue)value {
    MOSInstruction *instruction = [[MOSInstruction alloc] initWithOperand:value addressingMode:MOSAddressingModeImmediate];
    MOSOperation *operation = [[klass alloc] initWithInstruction:instruction];
    return operation;
}

- (void)testLoadRegisterX {
    MOSOperation *op = [self createOperation:MOSLoadRegisterXOperation.class withImmediateValue:0x55];
    [op execute:self.cpu];
    
    XCTAssertEqual(self.cpu.registerValues.x, 0x55);
    XCTAssertFalse(self.cpu.statusRegister.zeroFlag);
    XCTAssertFalse(self.cpu.statusRegister.negativeFlag);
}

- (void)testLoadRegisterXZero {
    MOSOperation *op = [self createOperation:MOSLoadRegisterXOperation.class withImmediateValue:0x0];
    [op execute:self.cpu];

    XCTAssertTrue(self.cpu.statusRegister.zeroFlag);
}

- (void)testLoadRegisterXNegative {
    MOSOperation *op = [self createOperation:MOSLoadRegisterXOperation.class withImmediateValue:0xFE];
    [op execute:self.cpu];

    XCTAssertTrue(self.cpu.statusRegister.negativeFlag);
}

- (void)testLoadRegisterY {
    MOSOperation *op = [self createOperation:MOSLoadRegisterYOperation.class withImmediateValue:0x55];
    [op execute:self.cpu];

    XCTAssertEqual(self.cpu.registerValues.y, 0x55);
    XCTAssertFalse(self.cpu.statusRegister.zeroFlag);
    XCTAssertFalse(self.cpu.statusRegister.negativeFlag);
}

- (void)testLoadRegisterYZero {
    MOSOperation *op = [self createOperation:MOSLoadRegisterYOperation.class withImmediateValue:0x0];
    [op execute:self.cpu];

    XCTAssertTrue(self.cpu.statusRegister.zeroFlag);
}

- (void)testLoadRegisterYNegative {
    MOSOperation *op = [self createOperation:MOSLoadRegisterYOperation.class withImmediateValue:0xFE];
    [op execute:self.cpu];

    XCTAssertTrue(self.cpu.statusRegister.negativeFlag);
}
@end
