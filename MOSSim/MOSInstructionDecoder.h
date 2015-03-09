#import <Foundation/Foundation.h>
#import "MOSTypes.h"

@interface MOSInstruction : NSObject

@property(nonatomic) MOSOPCode opcode;
@property(nonatomic) NSString *operationName;
@property(nonatomic) MOSAbsoluteAddress absoluteAddress;
@property(nonatomic) MOSRelativeAddress relativeAddress;
@property(nonatomic) MOSAddressingMode addressingMode;
@property(nonatomic) MOSPageOffset pageOffset;
@property(nonatomic) MOSImmediateValue immediateValue;

@end

@interface MOSInstructionDecoder : NSObject

- (instancetype)initWithDataStream:(id<MOSDataStream>)stream;

- (MOSInstruction *)decodeNextInstruction;

@end
