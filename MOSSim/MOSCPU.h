#import <Foundation/Foundation.h>
#import "MOSTypes.h"
#import "MOSRegisterValues.h"
#import "MOSStatusRegister.h"

@interface MOSCPU : NSObject

@property(nonatomic, readonly) MOSStatusRegister *statusRegister;
@property(nonatomic) MOSAbsoluteAddress programCounter;
@property(nonatomic, readonly) MOSRegisterValues *registerValues;

- (void)loadProgram:(NSData *)data;
- (void)step;
- (void)run;

@end
