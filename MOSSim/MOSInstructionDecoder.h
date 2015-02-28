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

typedef NS_ENUM(NSInteger, MOSOPCode) {
    MOSOPCodeCLC = 0x18,
    MOSOPCodeSEC = 0x38,
    
    MOSOPCodeCLD = 0xD8,
    
    MOSOPCodeJMP = 0x4C,
    MOSOPCodeBCC = 0x90,
    MOSOPCodeBCS = 0xB0,
    MOSOPCodeBEQ = 0xF0,
    MOSOPCodeBNE = 0xD0,
    
    MOSOPCodeINCZeroPage = 0xE6,
    MOSOPCodeINCZeroPageIndexed = 0xF6,
    MOSOPCodeINCAbsolute = 0xEE,
    MOSOPCodeINCAbsoluteIndexed = 0xFE,
    
    MOSOPCodeANDImmediate = 0x29,
    MOSOPCodeANDZeroPage = 0x25,
    MOSOPCodeANDZeroPageIndexed = 0x35,
    MOSOPCodeANDAbsolute = 0x2D,
    
    MOSOPCodeLDXImmediate = 0xA2,
    
    MOSOPCodeCPXImmediate = 0xE0,
};

typedef NS_ENUM(NSInteger, MOSOperation) {
    MOSOperationClearCarryFlag,
    MOSOperationSetCarryFlag,
    
    MOSOperationClearDecimalMode,
    
    MOSOperationJump,
    MOSOperationBranchOnCarryClear,
    MOSOperationBranchOnCarrySet,
    MOSOperationBranchOnResultZero,
    MOSOperationBranchOnResultNotZero,
    
    MOSOperationIncrementByOne,
    
    MOSOperationAND,
    MOSOperationLoadRegister,
    MOSOperationCompare
};

@class MOSInstruction;

@interface MOSInstructionDecoder : NSObject

- (instancetype)initWithDataStream:(id<MOSDataStream>)stream;

- (MOSInstruction *)decodeNextInstruction;

@end
