#import <Foundation/Foundation.h>
#import "MOSTypes.h"

@class MOSStatusRegister;
@class MOSRegisterBank;
@protocol MOSDataStream;

@interface MOSCPU : NSObject

@property(nonatomic, readonly) MOSStatusRegister *statusRegister;
@property(nonatomic) MOSAbsoluteAddress programCounter;
@property(nonatomic, readonly) MOSRegisterBank *registers;

- (void)loadProgram:(id<MOSDataStream>)data;
- (void)step;

@end
