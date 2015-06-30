#import <XCTest/XCTest.h>
#import "MOSCPU.h"
#import "MOSBranchOnResultZeroOperation.h"
#import "MOSInstruction.h"

@interface MOSBranchZeroTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;
@property(nonatomic) MOSOperation *operation;

@end

@implementation MOSBranchZeroTests

- (void)setUp {
    self.cpu = [MOSCPU new];
    MOSInstruction *instruction = [[MOSInstruction alloc] initWithOperand:0x05 addressingMode:MOSAddressingModeRelative];
    self.operation = [[MOSBranchOnResultZeroOperation alloc] initWithInstruction:instruction];
}

- (void)testWhenZero {
    self.cpu.programCounter = 123;
    self.cpu.statusRegister.zeroFlag = YES;
    [self.operation execute:self.cpu];
    
    XCTAssertEqual(self.cpu.programCounter, 128);
}

- (void)testWhenNotZero {
    self.cpu.programCounter = 123;
    self.cpu.statusRegister.zeroFlag = NO;
    [self.operation execute:self.cpu];

    XCTAssertEqual(self.cpu.programCounter, 123);
}

@end
