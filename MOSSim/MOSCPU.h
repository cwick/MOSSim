#import <Foundation/Foundation.h>
#import "MOSTypes.h"
#import "MOSRegisterValues.h"
#import "MOSStatusRegister.h"
#import "MOSAddressBus.h"

@interface MOSCPU : NSObject

@property(nonatomic, readonly) MOSStatusRegister *statusRegister;
@property(nonatomic) MOSAbsoluteAddress programCounter;
@property(nonatomic) MOSWord stackPointer;
@property(nonatomic, readonly) MOSRegisterValues *registerValues;
@property(nonatomic) BOOL isHalted;
@property(nonatomic, readonly) id<MOSAddressBus> addressBus;

- (void)step;
- (void)run;

- (MOSWord)readWordFromAddress:(MOSAbsoluteAddress)address;
- (void)writeWord:(MOSWord)value toAddress:(MOSAbsoluteAddress)address;

- (void)pushStack:(MOSWord)value;
- (MOSWord)popStack;

@end
