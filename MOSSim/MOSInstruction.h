#import <objc/NSObject.h>
#import "MOSTypes.h"

@class MOSCPU;

@interface MOSInstruction : NSObject

- (instancetype)initWithOperand:(MOSOperand)operand addressingMode:(MOSAddressingMode)mode;

- (MOSAbsoluteAddress)resolveAddress:(MOSCPU *)cpu;

@property(nonatomic) MOSOPCode opcode;
@property(nonatomic) NSString *operationName;
@property(nonatomic) MOSAbsoluteAddress absoluteAddress;
@property(nonatomic) MOSRelativeAddress relativeAddress;
@property(nonatomic) MOSAddressingMode addressingMode;
@property(nonatomic) MOSPageOffset pageOffset;
@property(nonatomic) MOSImmediateValue immediateValue;

@end
