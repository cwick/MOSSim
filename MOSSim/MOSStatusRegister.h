#import <Foundation/Foundation.h>
#import "MOSTypes.h"

@interface MOSStatusRegister : NSObject

@property(nonatomic) BOOL carryFlag;
@property(nonatomic) BOOL zeroFlag;
@property(nonatomic) BOOL negativeFlag;
@property(nonatomic) BOOL interruptDisable;
@property(nonatomic) BOOL decimalMode;

- (void)setZeroAndNegativeFlagsFromValue:(MOSWord)value;

@end
