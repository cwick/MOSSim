#import <XCTest/XCTest.h>

#import "MOSCPU.h"
#import "MOSDecrementRegisterOperation.h"

@interface MOSDecrementRegisterTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;
@property(nonatomic) MOSDecrementRegisterOperation *operation;

@end

@implementation MOSDecrementRegisterTests

- (void)setUp {
    self.cpu = [MOSCPU new];
    self.operation = [MOSDecrementRegisterOperation new];
}

- (void)testDecrementY {
    self.cpu.registerValues.y = 0x02;
    [self.operation execute:self.cpu];
    
    XCTAssertEqual(self.cpu.registerValues.y, 0x01);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, NO);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, NO);
}

- (void)testDecrementYWithZero {
    self.cpu.registerValues.y = 0x01;
    [self.operation execute:self.cpu];

    XCTAssertEqual(self.cpu.registerValues.y, 0x00);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, YES);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, NO);
}

- (void)testDecrementYWithOverflow {
    self.cpu.registerValues.y = 0x00;
    [self.operation execute:self.cpu];
    
    XCTAssertEqual(self.cpu.registerValues.y, 0xFF);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, NO);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, YES);
}

@end
