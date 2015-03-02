#import <XCTest/XCTest.h>

#import "MOSCPU.h"
#import "MOSClearCarryFlagOperation.h"
#import "MOSSetCarryFlagOperation.h"
#import "MOSJumpOperation.h"
#import "MOSLoadRegisterOperation.h"
#import "MOSCompareOperation.h"
#import "MOSReturnFromSubroutineOperation.h"

@interface MOSInstructionTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;

@end

@implementation MOSInstructionTests

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
    MOSOperation *op = [[MOSJumpOperation alloc] initWithAbsoluteAddress:0x1234];
    [op execute:self.cpu];
    
    XCTAssertEqual(self.cpu.programCounter, 0x1234);
}

- (void)testLoadRegister {
    MOSOperation *op = [[MOSLoadRegisterOperation alloc] initWithImmediateValue:0x55];
    [op execute:self.cpu];
    
    XCTAssertEqual(self.cpu.registerValues.x, 0x55);
    
}

- (void)testCompareX {
    MOSOperation *op = [[MOSCompareOperation alloc] initWithImmediateValue:0xFF];
    
    self.cpu.registerValues.x = 0xFF;
    [op execute:self.cpu];
    
    XCTAssertTrue(self.cpu.statusRegister.zeroFlag);
    
    self.cpu.registerValues.x = 0x12;
    [op execute:self.cpu];
    
    XCTAssertFalse(self.cpu.statusRegister.zeroFlag);
}

- (void)testReturnFromSubroutine {
    MOSOperation *op = [MOSReturnFromSubroutineOperation new];
    
    self.cpu.isHalted = NO;
    [op execute:self.cpu];
    XCTAssertTrue(self.cpu.isHalted);
}

@end
