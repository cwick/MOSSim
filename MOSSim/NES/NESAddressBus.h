#import "MOSAddressBus.h"

@class NESCartridge;

extern const int NES_RAM_START;
extern const int NES_RAM_END;
extern const int NES_RAM_SIZE;
extern const int NES_CARTRIDGE_START;
extern const int NES_CARTRIDGE_END;
extern const int NES_CARTRIDGE_SIZE;

@interface NESAddressBus : NSObject<MOSAddressBus>

@property(nonatomic) NESCartridge *cartridge;

@end