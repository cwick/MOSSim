#import "MOSUtils.h"

static const int BITS_PER_BYTE = 8;

MOSAbsoluteAddress MOSAbsoluteAddressMake(MOSWord high, MOSWord low) {
    return (high << BITS_PER_BYTE) | low;
}

BOOL MOSTest7thBit(MOSWord value) {
    const MOSWord bitMask = 0b10000000;
    return (value & bitMask) != 0;
}

MOSWord MOSAddressHigh(MOSAbsoluteAddress address) {
    return (address & 0xFF00) >> 8;
}

MOSWord MOSAddressLow(MOSAbsoluteAddress address) {
    return address & 0x00FF;
}
