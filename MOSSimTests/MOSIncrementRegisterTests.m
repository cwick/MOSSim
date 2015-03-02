#import <XCTest/XCTest.h>

#import "MOSCPU.h"
#import "MOSIncrementRegisterOperation.h"

@interface MOSIncrementRegisterTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;
@property(nonatomic) MOSIncrementRegisterOperation *operation;

@end

@implementation MOSIncrementRegisterTests

- (void)setUp {
    self.cpu = [MOSCPU new];
    self.operation = [MOSIncrementRegisterOperation new];
}

- (void)testIncrementX {
    self.cpu.registerValues.x = 0x00;
    [self.operation execute:self.cpu];
    
    XCTAssertEqual(self.cpu.registerValues.x, 0x01);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, NO);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, NO);
}

- (void)testIncrementXWithOverflow {
    self.cpu.registerValues.x = 0xFF;
    [self.operation execute:self.cpu];
    
    XCTAssertEqual(self.cpu.registerValues.x, 0x00);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, YES);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, NO);
}

- (void)testIncrementXWithNegative {
    self.cpu.registerValues.x = 127;
    [self.operation execute:self.cpu];
    
    XCTAssertEqual((MOSSignedRegisterValue)self.cpu.registerValues.x, -128);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, NO);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, YES);
}

@end
