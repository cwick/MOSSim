#import <XCTest/XCTest.h>
#import "MOSBranchOnResultNotZeroOperation.h"
#import "MOSCPU.h"

@interface MOSBranchNotZeroTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;

@end

@implementation MOSBranchNotZeroTests

- (void)setUp {
    self.cpu = [MOSCPU new];
}

- (void)testWhenZero {
    MOSOperation *op = [[MOSBranchOnResultNotZeroOperation alloc] initWithRelativeAddress:0x01];
    
    self.cpu.programCounter = 123;
    self.cpu.statusRegister.zeroFlag = YES;
    [op execute:self.cpu];
    
    XCTAssertEqual(self.cpu.programCounter, 123);
}

- (void)testWhenNotZero {
    MOSOperation *op = [[MOSBranchOnResultNotZeroOperation alloc] initWithRelativeAddress:0x01];
    
    self.cpu.programCounter = 123;
    self.cpu.statusRegister.zeroFlag = NO;
    [op execute:self.cpu];
    
    XCTAssertEqual(self.cpu.programCounter, 124);
}

@end
