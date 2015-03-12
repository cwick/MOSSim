#import <XCTest/XCTest.h>

#import "MOSCPU.h"
#import "MOSUtils.h"
#import "MOSClearCarryFlagOperation.h"
#import "MOSSetCarryFlagOperation.h"
#import "MOSJumpOperation.h"
#import "MOSReturnFromSubroutineOperation.h"
#import "MOSJumpToSubroutineOperation.h"
#import "MOSTransferXToStackPointerOperation.h"
#import "MOSInstructionDecoder.h"

@interface MOSOperationTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;

@end

@implementation MOSOperationTests

- (void)setUp {
    self.cpu = [MOSCPU new];
}

- (void)testClearCarryFlag {
    MOSOperation *op = [MOSClearCarryFlagOperation new];
    [op execute:self.cpu];
    
    XCTAssertFalse(self.cpu.statusRegister.carryFlag);
}

- (void)testSetCarryFlag {
    MOSOperation *op = [MOSSetCarryFlagOperation new];
    [op execute:self.cpu];
    
    XCTAssertTrue(self.cpu.statusRegister.carryFlag);
}

- (void)testJump {
    MOSInstruction *instruction = [[MOSInstruction alloc] initWithOperand:0x1234 addressingMode:MOSAddressingModeAbsolute];
    MOSOperation *op = [[MOSJumpOperation alloc] initWithInstruction:instruction];
    [op execute:self.cpu];
    
    XCTAssertEqual(self.cpu.programCounter, 0x1234);
}

- (void)testTransferXToStackPointer {
    MOSOperation *op = [MOSTransferXToStackPointerOperation new];
    self.cpu.registerValues.x = 123;
    [op execute:self.cpu];
    
    XCTAssertEqual(self.cpu.stackPointer, 123);
}

- (void)testReturnFromSubroutine {
    MOSOperation *op = [MOSReturnFromSubroutineOperation new];
    MOSAbsoluteAddress returnAddress = 0x1234;
    
    self.cpu.programCounter = 0x0;
    self.cpu.stackPointer = 2;
    [self.cpu pushStack:MOSAddressHigh(returnAddress)];
    [self.cpu pushStack:MOSAddressLow(returnAddress)];
    
    [op execute:self.cpu];
    
    XCTAssertEqual(self.cpu.stackPointer, 2);
    XCTAssertEqual(self.cpu.programCounter, 0x1235);
}

- (void)testJumpToSubroutineOperation {
    MOSInstruction *instruction = [[MOSInstruction alloc] initWithOperand:0x1234 addressingMode:MOSAddressingModeAbsolute];
    MOSOperation *op = [[MOSJumpToSubroutineOperation alloc] initWithInstruction:instruction];

    self.cpu.programCounter = 3;
    self.cpu.stackPointer = 2;
    
    [op execute:self.cpu];
    XCTAssertEqual(self.cpu.programCounter, 0x1234);
    XCTAssertEqual(self.cpu.stackPointer, 0);
    
    MOSWord returnAddressLow = [self.cpu popStack];
    MOSWord returnAddressHigh = [self.cpu popStack];
    
    MOSAbsoluteAddress returnAddress = MOSAbsoluteAddressMake(returnAddressLow, returnAddressHigh);
    XCTAssertEqual(returnAddress, 0x0002);
}

@end
