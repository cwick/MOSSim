#import "MOSOperation.h"
#import "MOSTypes.h"

@interface MOSLoadRegisterOperation : MOSOperation

- (instancetype)initWithImmediateValue:(MOSImmediateValue)value register:(NSString *)reg;
@property(nonatomic, readonly) MOSImmediateValue value;
@property(nonatomic, readonly) NSString *registerToLoad;

@end
