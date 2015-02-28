#import <Foundation/Foundation.h>
#import "MOSTypes.h"
#import "MOSRegisterValues.h"
#import "MOSStatusRegister.h"

@protocol MOSDataStream;

@interface MOSCPU : NSObject

@property(nonatomic, readonly) MOSStatusRegister *statusRegister;
@property(nonatomic) MOSAbsoluteAddress programCounter;
@property(nonatomic, readonly) MOSRegisterValues *registerValues;

- (void)loadProgram:(id<MOSDataStream>)data;
- (void)step;
- (void)run;

@end
