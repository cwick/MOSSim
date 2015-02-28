#import "MOSOperation.h"
#import "MOSTypes.h"

@interface MOSLoadRegisterOperation : MOSOperation

- (instancetype)initWithImmediateValue:(MOSImmediateValue)value;
@property(nonatomic, readonly) MOSImmediateValue value;

@end
