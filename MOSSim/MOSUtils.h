#import "MOSTypes.h"

MOSAbsoluteAddress MOSAbsoluteAddressMake(MOSWord high, MOSWord low);
MOSWord MOSAddressHigh(MOSAbsoluteAddress address);
MOSWord MOSAddressLow(MOSAbsoluteAddress address);

BOOL MOSTest7thBit(MOSWord value);
