#import "MOSUtils.h"

static const int BITS_PER_BYTE = 8;

MOSAbsoluteAddress MOSAbsoluteAddressMake(MOSWord high, MOSWord low) {
    return (high << BITS_PER_BYTE) | low;
}

BOOL MOSTest7thBit(MOSWord value) {
    const MOSWord bitMask = 0b10000000;
    return (value & bitMask) != 0;
}
