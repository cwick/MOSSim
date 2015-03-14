#import <Foundation/Foundation.h>
#import "MOSTypes.h"
#import "MOSRegisterValues.h"
#import "MOSStatusRegister.h"

extern const int MOS_ADDRESS_SPACE_SIZE;

@interface MOSCPU : NSObject

@property(nonatomic, readonly) MOSStatusRegister *statusRegister;
@property(nonatomic) MOSAbsoluteAddress programCounter;
@property(nonatomic) MOSWord stackPointer;
@property(nonatomic, readonly) MOSRegisterValues *registerValues;
@property(nonatomic) BOOL isHalted;

- (void)step;
- (void)run;

- (MOSWord)readWordFromAddress:(MOSAbsoluteAddress)address;
- (void)writeWord:(MOSWord)value toAddress:(MOSAbsoluteAddress)address;

- (void)pushStack:(MOSWord)value;
- (MOSWord)popStack;

- (void)loadBinaryImage:(NSData *)data;

@end
