#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MOSAddressingMode) {
    MOSAddressingModeImplied,
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
};

typedef uint16_t MOSAbsoluteAddress;
typedef int8_t MOSRelativeAddress;
typedef uint8_t MOSWord;
typedef uint8_t MOSPageOffset;

MOSAbsoluteAddress MOSAbsoluteAddressMake(MOSWord high, MOSWord low);

@protocol MOSDataStream <NSObject>

- (MOSWord)nextWord;

@end

@interface MOSInstruction : NSObject

@property(nonatomic) MOSOPCode opcode;
@property(nonatomic) MOSOperation operation;
@property(nonatomic) MOSAbsoluteAddress absoluteAddress;
@property(nonatomic) MOSRelativeAddress relativeAddress;
@property(nonatomic) MOSAddressingMode addressingMode;
@property(nonatomic) BOOL isAddressingModeIndexed;
@property(nonatomic) MOSPageOffset pageOffset;

@end

@interface MOSInstructionDecoder : NSObject

- (instancetype)initWithDataStream:(id<MOSDataStream>)stream;

- (MOSInstruction *)decodeNextInstruction;

@end
