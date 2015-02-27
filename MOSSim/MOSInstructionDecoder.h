#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MOSOPCode) {
    MOSOPCodeClearCarryFlag = 0x18,
    MOSOPCodeSetCarryFlag = 0x38,
    
    MOSOPCodeClearDecimalMode = 0xD8
};

@interface MOSInstructionDecoder : NSObject

- (MOSOPCode)decodeInstruction:(NSInteger)opcode;

@end
