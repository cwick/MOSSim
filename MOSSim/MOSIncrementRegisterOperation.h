#import "MOSOperation.h"
#import "MOSTypes.h"

@interface MOSIncrementRegisterOperation : MOSOperation

- (id)initWithInstruction:(MOSInstruction *)instruction register:(NSString *)reg;

@property (nonatomic, copy) NSString * registerToIncrement;

@end
