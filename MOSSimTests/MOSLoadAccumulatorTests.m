#import <XCTest/XCTest.h>
#import "MOSLoadAccumulatorOperation.h"
#import "MOSCPU.h"
#import "MOSOperation.h"

@interface MOSLoadAccumulatorTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;

@end

@implementation MOSLoadAccumulatorTests

- (void)setUp {
    self.cpu = [MOSCPU new];
}

- (void)testLoadImmediate {
    MOSOperation *op = [[MOSLoadAccumulatorOperation alloc] initWithImmediateValue:123];
    [op execute:self.cpu];
    XCTAssertEqual(self.cpu.registerValues.a, 123);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, NO);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, NO);
}

- (void)testLoadImmediateZero {
    MOSOperation *op = [[MOSLoadAccumulatorOperation alloc] initWithImmediateValue:0];
    [op execute:self.cpu];
    XCTAssertEqual(self.cpu.registerValues.a, 0);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, YES);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, NO);
}

- (void)testLoadImmediateNegative {
    MOSOperation *op = [[MOSLoadAccumulatorOperation alloc] initWithImmediateValue:-12];
    [op execute:self.cpu];
    XCTAssertEqual((MOSSignedRegisterValue)self.cpu.registerValues.a, -12);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, NO);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, YES);
}

- (void)testLoadZeroPage {
    MOSOperation *op = [[MOSLoadAccumulatorOperation alloc] initWithPageOffset:0x10];
    [self.cpu writeWord:0xFF toAddress:0x10];
    [op execute:self.cpu];

    XCTAssertEqual(self.cpu.registerValues.a, 0xFF);
    XCTAssertEqual(self.cpu.statusRegister.zeroFlag, NO);
    XCTAssertEqual(self.cpu.statusRegister.negativeFlag, YES);
}
@end
