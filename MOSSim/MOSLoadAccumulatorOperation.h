#import "MOSOperation.h"
#import "MOSTypes.h"

@interface MOSLoadAccumulatorOperation : MOSOperation

- (instancetype)initWithImmediateValue:(MOSImmediateValue)value;
- (instancetype)initWithPageOffset:(MOSPageOffset)offset;

@end
