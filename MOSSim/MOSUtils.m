#import "MOSUtils.h"

static const int BITS_PER_BYTE = 8;

MOSAbsoluteAddress MOSAbsoluteAddressMake(MOSWord low, MOSWord high) {
    return (high << BITS_PER_BYTE) | low;
}

BOOL MOSTestHighBit(MOSWord value) {
    const MOSWord bitMask = (MOSWord const) 0b10000000;
    return (value & bitMask) != 0;
}

MOSWord MOSAddressHigh(MOSAbsoluteAddress address) {
    return (MOSWord) ((address & 0xFF00) >> 8);
}

MOSWord MOSAddressLow(MOSAbsoluteAddress address) {
    return (MOSWord) (address & 0x00FF);
}
