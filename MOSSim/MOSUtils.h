#import "MOSTypes.h"

MOSAbsoluteAddress MOSAbsoluteAddressMake(MOSWord low, MOSWord high);
MOSWord MOSAddressHigh(MOSAbsoluteAddress address);
MOSWord MOSAddressLow(MOSAbsoluteAddress address);

BOOL MOSTestHighBit(MOSWord value);
