#import <Foundation/Foundation.h>
#import "MOSTypes.h"

@class MOSStatusRegister;

@interface MOSCPU : NSObject

@property(nonatomic, readonly) MOSStatusRegister *statusRegister;
@property(nonatomic) MOSAbsoluteAddress programCounter;

@end
