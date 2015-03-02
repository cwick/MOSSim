#import <XCTest/XCTest.h>

#import "MOSCPU.h"
#import "MOSCompareOperation.h"

@interface MOSCompareOperationTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;

@end

@implementation MOSCompareOperationTests

- (void)setUp {
    self.cpu = [MOSCPU new];
}

- (void)testCompareXEqualImmediate {
    MOSOperation *op = [[MOSCompareOperation alloc] initWithImmediateValue:0xFF];
    
    self.cpu.registerValues.x = 0xFF;
    [op execute:self.cpu];
    
    XCTAssertTrue(self.cpu.statusRegister.zeroFlag);
    XCTAssertFalse(self.cpu.statusRegister.negativeFlag);
    XCTAssertTrue(self.cpu.statusRegister.carryFlag);
    
}

- (void)testCompareXNotEqualImmediate {
    MOSOperation *op = [[MOSCompareOperation alloc] initWithImmediateValue:0x20];
    self.cpu.registerValues.x = 0x00;
    [op execute:self.cpu];
    
    XCTAssertFalse(self.cpu.statusRegister.zeroFlag);
    XCTAssertTrue(self.cpu.statusRegister.negativeFlag);
    XCTAssertFalse(self.cpu.statusRegister.carryFlag);
}

@end
