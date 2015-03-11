#import "MOSOperation.h"
#import "MOSTypes.h"
#import "MOSLoadRegisterOperation.h"

@interface MOSLoadRegisterYOperation : MOSLoadRegisterOperation

- (instancetype)initWithImmediateValue:(MOSImmediateValue)value;

@end
