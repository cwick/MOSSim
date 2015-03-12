#import "MOSOperation.h"
#import "MOSTypes.h"

@interface MOSStoreAccumulatorOperation : MOSOperation

- (instancetype)initWithOperand:(MOSWord)operand addressingMode:(MOSAddressingMode)mode;

@end
