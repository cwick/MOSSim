#import "MOSStatusRegister.h"
#import "MOSUtils.h"

@implementation MOSStatusRegister

- (void)setZeroAndNegativeFlagsFromValue:(MOSWord)value {
    self.zeroFlag = (value == 0);
    self.negativeFlag = MOSTestHighBit(value);
}


@end
