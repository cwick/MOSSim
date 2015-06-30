#import <Foundation/Foundation.h>
#import "MOSTypes.h"

@class MOSCPU;
@class MOSInstruction;

@interface MOSInstructionDecoder : NSObject

- (instancetype)initWithDataStream:(id<MOSDataStream>)stream;

- (MOSInstruction *)decodeNextInstruction;

@end
