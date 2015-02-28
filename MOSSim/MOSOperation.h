#import <Foundation/Foundation.h>

@class MOSCPU;
@class MOSInstruction;

@interface MOSOperation : NSObject

- (instancetype)initWithInstruction:(MOSInstruction *)instruction;

- (void)execute:(MOSCPU *)cpu;

@end
