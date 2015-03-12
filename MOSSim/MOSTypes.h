#import <Foundation/Foundation.h>

typedef uint16_t MOSAbsoluteAddress;
typedef int8_t   MOSRelativeAddress;
typedef uint8_t  MOSWord;
typedef uint8_t  MOSRegisterValue;
typedef int8_t   MOSSignedRegisterValue;
typedef uint8_t  MOSPageOffset;
typedef MOSWord  MOSImmediateValue;

@protocol MOSDataStream <NSObject>

- (MOSWord)nextWord;

@end

typedef NS_ENUM(NSInteger, MOSAddressingMode) {
    MOSAddressingModeImplied,
    MOSAddressingModeImmediate,
    MOSAddressingModeZeroPage,
    MOSAddressingModeZeroPageX,
    MOSAddressingModeAbsolute,
    MOSAddressingModeAbsoluteX,
    MOSAddressingModeRelative,
    MOSAddressingModeIndirectIndexed,
};

typedef NS_ENUM(NSInteger, MOSOPCode) {
    MOSOPCodeCLC = 0x18,
    MOSOPCodeSEC = 0x38,
    MOSOPCodeINX = 0xE8,
    MOSOPCodeDEY = 0x88,
    MOSOPCodeRTS = 0x60,
    MOSOPCodeBRK = 0x00,
    MOSOPCodeTXS = 0x9A,
    
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
    MOSOPCodeLDYImmediate = 0xA0,

    MOSOPCodeSTXZeroPage = 0x86,

    MOSOPCodeCPXImmediate = 0xE0,

    MOSOPCodeLDAImmediate = 0xA9,
    MOSOPCodeLDAZeroPage = 0xA5,
    MOSOPCodeLDAIndirectIndexed = 0xB1,

    MOSOPCodeSTAZeroPage = 0x85,
    MOSOPCodeSTAIndirectIndexed = 0x91,

    MOSOPCodeJSR = 0x20
};
