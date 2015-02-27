#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MOSOPCode) {
    MOSOPCodeClearCarryFlag = 0x18,
    MOSOPCodeSetCarryFlag = 0x38,
    
    MOSOPCodeClearDecimalMode = 0xD8,
    
    MOSOPCodeJump = 0x4C
};

typedef uint16_t MOSAddress;
typedef uint8_t MOSWord;

MOSAddress MOSAddressMake(MOSWord high, MOSWord low);

@protocol MOSDataStream <NSObject>

- (MOSWord)nextWord;

@end

@interface MOSInstruction : NSObject

@property(nonatomic) MOSOPCode opcode;
@property(nonatomic) MOSAddress address;

@end

@interface MOSInstructionDecoder : NSObject

- (instancetype)initWithDataStream:(id<MOSDataStream>)stream;

- (MOSInstruction *)decodeNextInstruction;

@end