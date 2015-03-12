#import <Foundation/Foundation.h>
#import "MOSTypes.h"

@class MOSCPU;

@interface MOSInstruction : NSObject

- (instancetype)initWithOperand:(MOSOperand)operand addressingMode:(MOSAddressingMode)mode;

- (MOSOperand)resolveOperand:(MOSCPU *)cpu;

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
