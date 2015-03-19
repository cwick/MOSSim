#import <Foundation/Foundation.h>
#import "MOSTypes.h"
#import "MOSRegisterValues.h"
#import "MOSStatusRegister.h"
#import "MOSDevice.h"

extern const int MOS_ADDRESS_SPACE_SIZE;

@interface MOSCPU : NSObject<MOSDevice>

@property(nonatomic, readonly) MOSStatusRegister *statusRegister;
@property(nonatomic) MOSAbsoluteAddress programCounter;
@property(nonatomic) MOSWord stackPointer;
@property(nonatomic, readonly) MOSRegisterValues *registerValues;
@property(nonatomic) BOOL isHalted;

- (void)step;
- (void)run;

- (void)pushStack:(MOSWord)value;
- (MOSWord)popStack;

- (void)loadBinaryImage:(NSData *)data;

@end
