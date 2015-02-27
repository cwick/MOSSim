#import <XCTest/XCTest.h>

#import "MOSInstruction.h"
#import "MOSClearCarryFlagOperation.h"
#import "MOSSetCarryFlagOperation.h"
#import "MOSJumpOperation.h"
#import "MOSCPU.h"
#import "MOSStatusRegister.h"

@interface MOSInstructionTests : XCTestCase

@property(nonatomic) MOSCPU *cpu;

@end

@implementation MOSInstructionTests

- (void)setUp {
    self.cpu = [MOSCPU new];
}

- (void)testClearCarryFlag {
    id<MOSOperation> op = [MOSClearCarryFlagOperation new];
    [op execute:self.cpu];
    
    XCTAssertFalse(self.cpu.statusRegister.carryFlag);
}

- (void)testSetCarryFlag {
    id<MOSOperation> op = [MOSSetCarryFlagOperation new];
    [op execute:self.cpu];
    
    XCTAssertTrue(self.cpu.statusRegister.carryFlag);
}

- (void)testJump {
    id<MOSOperation> op = [[MOSJumpOperation alloc] initWithAbsoluteAddress:0x1234];
    [op execute:self.cpu];
    
    XCTAssertEqual(self.cpu.programCounter, 0x1234);
}

@end
