#import <Foundation/Foundation.h>
#import "MOSTypes.h"
#import "MOSRegisterValues.h"
#import "MOSStatusRegister.h"

@interface MOSCPU : NSObject

@property(nonatomic, readonly) MOSStatusRegister *statusRegister;
@property(nonatomic) MOSAbsoluteAddress programCounter;
@property(nonatomic) MOSAbsoluteAddress stackPointer;
@property(nonatomic, readonly) MOSRegisterValues *registerValues;
@property(nonatomic) BOOL isHalted;

- (void)loadProgram:(NSData *)data;
- (void)step;
- (void)run;

- (MOSWord)readWord:(MOSAbsoluteAddress)address;

- (void)pushStack:(MOSWord)value;
- (MOSWord)popStack;

@end
