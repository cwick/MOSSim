#import "MOSOperation.h"
#import "MOSTypes.h"

@interface MOSLoadRegisterOperation : NSObject<MOSOperation>

- (instancetype)initWithImmediateValue:(MOSImmediateValue)value;
@property(nonatomic, readonly) MOSImmediateValue value;

@end
