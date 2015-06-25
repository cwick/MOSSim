#import "MOSOperation.h"
#import "MOSTypes.h"

@interface MOSCompareOperation : MOSOperation

- (id)initWithInstruction:(MOSInstruction *)instruction register:(NSString *)reg;

@property(nonatomic, readonly) NSString *registerToCompare;

@end
