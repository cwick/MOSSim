#import "MOSOperation.h"
#import "MOSTypes.h"
#import "MOSLoadRegisterOperation.h"

@interface MOSLoadRegisterXOperation : MOSLoadRegisterOperation

- (instancetype)initWithImmediateValue:(MOSImmediateValue)value;

@end
