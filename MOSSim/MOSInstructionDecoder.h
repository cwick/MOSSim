#import <Foundation/Foundation.h>
#import "MOSTypes.h"

typedef NS_ENUM(NSInteger, MOSAddressingMode) {
    MOSAddressingModeImplied,
    MOSAddressingModeImmediate,
    MOSAddressingModeZeroPage,
    MOSAddressingModeAbsolute,
    MOSAddressingModeRelative,
    MOSAddressingModeIndexed,
};

@class MOSInstruction;

@interface MOSInstructionDecoder : NSObject

- (instancetype)initWithDataStream:(id<MOSDataStream>)stream;

- (MOSInstruction *)decodeNextInstruction;

@end
