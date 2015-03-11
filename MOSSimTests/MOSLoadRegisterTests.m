#import <XCTest/XCTest.h>

#import "MOSCPU.h"
#import "MOSLoadRegisterXOperation.h"
#import "MOSLoadRegisterYOperation.h"

@interface MOSLoadRegisterTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;

@end

@implementation MOSLoadRegisterTests

- (void)setUp {
    self.cpu = [MOSCPU new];
}

- (void)testLoadRegisterX {
    MOSOperation *op = [[MOSLoadRegisterXOperation alloc] initWithImmediateValue:0x55];
    [op execute:self.cpu];
    
    XCTAssertEqual(self.cpu.registerValues.x, 0x55);
    XCTAssertFalse(self.cpu.statusRegister.zeroFlag);
    XCTAssertFalse(self.cpu.statusRegister.negativeFlag);
}

- (void)testLoadRegisterXZero {
    MOSOperation *op = [[MOSLoadRegisterXOperation alloc] initWithImmediateValue:0x0];
    [op execute:self.cpu];

    XCTAssertTrue(self.cpu.statusRegister.zeroFlag);
}

- (void)testLoadRegisterXNegative {
    MOSOperation *op = [[MOSLoadRegisterXOperation alloc] initWithImmediateValue:0xFE];
    [op execute:self.cpu];

    XCTAssertTrue(self.cpu.statusRegister.negativeFlag);
}

- (void)testLoadRegisterY {
    MOSOperation *op = [[MOSLoadRegisterYOperation alloc] initWithImmediateValue:0x55];
    [op execute:self.cpu];

    XCTAssertEqual(self.cpu.registerValues.y, 0x55);
    XCTAssertFalse(self.cpu.statusRegister.zeroFlag);
    XCTAssertFalse(self.cpu.statusRegister.negativeFlag);
}

- (void)testLoadRegisterYZero {
    MOSOperation *op = [[MOSLoadRegisterYOperation alloc] initWithImmediateValue:0x0];
    [op execute:self.cpu];

    XCTAssertTrue(self.cpu.statusRegister.zeroFlag);
}

- (void)testLoadRegisterYNegative {
    MOSOperation *op = [[MOSLoadRegisterYOperation alloc] initWithImmediateValue:0xFE];
    [op execute:self.cpu];

    XCTAssertTrue(self.cpu.statusRegister.negativeFlag);
}
@end
