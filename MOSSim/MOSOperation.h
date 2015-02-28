#import <Foundation/Foundation.h>

@class MOSCPU;
@class MOSInstruction;

@interface MOSOperation : NSObject

+ (MOSOperation *)operationFromInstruction:(MOSInstruction *)instruction;

- (instancetype)initWithInstruction:(MOSInstruction *)instruction;
- (void)execute:(MOSCPU *)cpu;

@end
