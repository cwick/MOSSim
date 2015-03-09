#import "MOSOperation.h"
#import "MOSTypes.h"

@interface MOSLoadAccumulatorOperation : MOSOperation

- (instancetype)initWithOperand:(MOSWord)operand addressingMode:(MOSAddressingMode)mode;

@end
