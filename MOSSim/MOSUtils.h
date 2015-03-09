#import "MOSTypes.h"

MOSAbsoluteAddress MOSAbsoluteAddressMake(MOSWord low, MOSWord high);
MOSWord MOSAddressHigh(MOSAbsoluteAddress address);
MOSWord MOSAddressLow(MOSAbsoluteAddress address);

BOOL MOSTest7thBit(MOSWord value);
