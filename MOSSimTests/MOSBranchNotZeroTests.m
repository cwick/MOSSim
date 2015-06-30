#import <XCTest/XCTest.h>
#import "MOSBranchOnResultNotZeroOperation.h"
#import "MOSCPU.h"
#import "MOSInstruction.h"

@interface MOSBranchNotZeroTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;
@property(nonatomic) MOSOperation *operation;

@end

@implementation MOSBranchNotZeroTests

- (void)setUp {
    self.cpu = [MOSCPU new];
    MOSInstruction *instruction = [[MOSInstruction alloc] initWithOperand:0x01 addressingMode:MOSAddressingModeRelative];
    self.operation = [[MOSBranchOnResultNotZeroOperation alloc] initWithInstruction:instruction];
}

- (void)testWhenZero {
    self.cpu.programCounter = 123;
    self.cpu.statusRegister.zeroFlag = YES;
    [self.operation execute:self.cpu];
    
    XCTAssertEqual(self.cpu.programCounter, 123);
}

- (void)testWhenNotZero {
    self.cpu.programCounter = 123;
    self.cpu.statusRegister.zeroFlag = NO;
    [self.operation execute:self.cpu];

    XCTAssertEqual(self.cpu.programCounter, 124);
}

@end
