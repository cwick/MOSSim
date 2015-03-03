#import <XCTest/XCTest.h>

#import "MOSCPU.h"
#import "MOSUtils.h"
#import "MOSClearCarryFlagOperation.h"
#import "MOSSetCarryFlagOperation.h"
#import "MOSJumpOperation.h"
#import "MOSLoadRegisterOperation.h"
#import "MOSReturnFromSubroutineOperation.h"
#import "MOSJumpToSubroutineOperation.h"

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
    MOSOperation *op = [[MOSJumpOperation alloc] initWithAbsoluteAddress:0x1234];
    [op execute:self.cpu];
    
    XCTAssertEqual(self.cpu.programCounter, 0x1234);
}

- (void)testLoadRegister {
    MOSOperation *op = [[MOSLoadRegisterOperation alloc] initWithImmediateValue:0x55];
    [op execute:self.cpu];
    
    XCTAssertEqual(self.cpu.registerValues.x, 0x55);
    
}

- (void)testReturnFromSubroutine {
    MOSOperation *op = [MOSReturnFromSubroutineOperation new];
    
    self.cpu.isHalted = NO;
    [op execute:self.cpu];
    XCTAssertTrue(self.cpu.isHalted);
}

- (void)testJumpToSubroutineOperation {
    MOSOperation *op = [[MOSJumpToSubroutineOperation alloc] initWithAbsoluteAddress:0x1234];
    
    self.cpu.programCounter = 3;
    self.cpu.stackPointer = 2;
    
    [op execute:self.cpu];
    XCTAssertEqual(self.cpu.programCounter, 0x1234);
    XCTAssertEqual(self.cpu.stackPointer, 0);
    MOSAbsoluteAddress expectedAddressOnStack = MOSAbsoluteAddressMake([self.cpu readWord:self.cpu.stackPointer+2],
                                                                       [self.cpu readWord:self.cpu.stackPointer+1]);
    XCTAssertEqual(expectedAddressOnStack, 0x0002);
}

@end
