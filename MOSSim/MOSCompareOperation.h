#import "MOSOperation.h"
#import "MOSTypes.h"

@interface MOSCompareOperation : MOSOperation

- (instancetype)initWithImmediateValue:(MOSImmediateValue)value;
@property(nonatomic, readonly) MOSImmediateValue value;

@end
