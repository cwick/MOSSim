#import "MOSLoadAccumulatorOperation.h"
#import "MOSCPU.h"

@interface MOSLoadAccumulatorOperation()

@property(nonatomic) MOSImmediateValue immediateValue;

@end

@implementation MOSLoadAccumulatorOperation

- (instancetype)initWithImmediateValue:(MOSImmediateValue)value {
    self = [super init];
    if (self) {
        _immediateValue = value;
    }

    return self;
}

//- (instancetype)initWithInstruction:(MOSInstruction *)instruction {
//    return [super init];
//}
//
- (void)execute:(MOSCPU *)cpu {
    cpu.registerValues.a = self.immediateValue;
}

@end
