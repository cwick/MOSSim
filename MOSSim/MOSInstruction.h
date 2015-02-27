#import "MOSInstructionDecoder.h"

@interface MOSInstruction : NSObject

- (instancetype)initWithOPCode:(MOSOPCode)opcode decoder:(MOSInstructionDecoder *)decoder;

@property(nonatomic, readonly) MOSOPCode opcode;
@property(nonatomic, readonly) MOSOperation operation;
@property(nonatomic, readonly) MOSAbsoluteAddress absoluteAddress;
@property(nonatomic, readonly) MOSRelativeAddress relativeAddress;
@property(nonatomic, readonly) MOSAddressingMode addressingMode;
@property(nonatomic, readonly) BOOL isAddressingModeIndexed;
@property(nonatomic, readonly) MOSPageOffset pageOffset;
@property(nonatomic, readonly) MOSImmediateValue immediateValue;

@end

