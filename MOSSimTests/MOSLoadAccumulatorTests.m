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
}

@end
