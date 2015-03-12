#import "MOSOperation.h"
#import "MOSTypes.h"

@interface MOSLoadRegisterOperation : MOSOperation

- (instancetype)initWithInstruction:(MOSInstruction *)instruction register:(NSString *)reg;

@property(nonatomic, readonly) NSString *registerToLoad;

@end
