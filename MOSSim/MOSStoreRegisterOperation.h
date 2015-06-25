#import "MOSOperation.h"
#import "MOSTypes.h"

@interface MOSStoreRegisterOperation : MOSOperation

- (instancetype)initWithInstruction:(MOSInstruction *)instruction register:(NSString *)reg;

@property(nonatomic, readonly) NSString *registerToStore;

@end
