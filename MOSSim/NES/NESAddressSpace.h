#import "MOSDevice.h"

extern const int NES_RAM_START;
extern const int NES_RAM_END;
extern const int NES_RAM_SIZE;
extern const int NES_CARTRIDGE_START;
extern const int NES_CARTRIDGE_END;
extern const int NES_CARTRIDGE_SIZE;

@protocol MOSDevice;

@interface NESAddressSpace : NSObject<MOSDevice>

@property(nonatomic) id<MOSDevice> cartridge;

@end