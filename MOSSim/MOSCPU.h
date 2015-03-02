#import <Foundation/Foundation.h>
#import "MOSTypes.h"
#import "MOSRegisterValues.h"
#import "MOSStatusRegister.h"

@interface MOSCPU : NSObject

+ (BOOL)is7thBitSet:(MOSWord)value;

@property(nonatomic, readonly) MOSStatusRegister *statusRegister;
@property(nonatomic) MOSAbsoluteAddress programCounter;
@property(nonatomic, readonly) MOSRegisterValues *registerValues;
@property(nonatomic) BOOL isHalted;

- (void)loadProgram:(NSData *)data;
- (void)step;
- (void)run;

@end
