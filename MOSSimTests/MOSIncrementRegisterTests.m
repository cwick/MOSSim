#import <XCTest/XCTest.h>

#import "MOSCPU.h"
#import "MOSIncrementRegisterOperation.h"
#import "MOSIncrementRegisterXOperation.h"
#import "MOSIncrementRegisterYOperation.h"

@interface MOSIncrementRegisterTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;
@property(nonatomic) MOSIncrementRegisterOperation *operationX;
@property(nonatomic) MOSIncrementRegisterOperation *operationY;

@end

@implementation MOSIncrementRegisterTests

- (void)setUp {
    self.cpu = [MOSCPU new];
    self.operationX = [[MOSIncrementRegisterXOperation alloc] initWithInstruction:nil];
    self.operationY = [[MOSIncrementRegisterYOperation alloc] initWithInstruction:nil];
}

- (void)testIncrementX {
    self.cpu.registerValues.x = 0x00;
    [self.operationX execute:self.cpu];
    
    XCTAssertEqual(self.cpu.registerValues.x, 0x01);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, NO);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, NO);
}

- (void)testIncrementY {
    self.cpu.registerValues.y = 0x00;
    [self.operationY execute:self.cpu];

    XCTAssertEqual(self.cpu.registerValues.y, 0x01);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, NO);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, NO);
}

- (void)testIncrementXWithOverflow {
    self.cpu.registerValues.x = 0xFF;
    [self.operationX execute:self.cpu];
    
    XCTAssertEqual(self.cpu.registerValues.x, 0x00);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, YES);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, NO);
}

- (void)testIncrementYWithOverflow {
    self.cpu.registerValues.y = 0xFF;
    [self.operationY execute:self.cpu];

    XCTAssertEqual(self.cpu.registerValues.y, 0x00);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, YES);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, NO);
}

- (void)testIncrementXWithNegative {
    self.cpu.registerValues.x = 127;
    [self.operationX execute:self.cpu];
    
    XCTAssertEqual((MOSSignedRegisterValue)self.cpu.registerValues.x, -128);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, NO);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, YES);
}

- (void)testIncrementYWithNegative {
    self.cpu.registerValues.y = 127;
    [self.operationY execute:self.cpu];

    XCTAssertEqual((MOSSignedRegisterValue)self.cpu.registerValues.y, -128);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, NO);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, YES);
}

@end
