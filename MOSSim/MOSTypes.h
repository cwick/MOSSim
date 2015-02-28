#import <Foundation/Foundation.h>

typedef uint16_t MOSAbsoluteAddress;
typedef int8_t MOSRelativeAddress;
typedef uint8_t MOSWord;
typedef uint8_t MOSRegisterValue;
typedef uint8_t MOSPageOffset;
typedef MOSWord MOSImmediateValue;

@protocol MOSDataStream <NSObject>

- (MOSWord)nextWord;
- (void)seek:(MOSAbsoluteAddress)address;

@end

