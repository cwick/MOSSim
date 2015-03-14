#import "MOSSimpleAddressBus.h"
#import "MOSCPU.h"

@interface MOSSimpleAddressBus()

@property(nonatomic) NSMutableData *data;

@end

@implementation MOSSimpleAddressBus {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [NSMutableData dataWithLength:MOS_ADDRESS_SPACE_SIZE];
    }

    return self;
}

- (MOSWord)readWordFromAddress:(MOSAbsoluteAddress)address {
    return ((MOSWord *)self.data.bytes)[address];
}

- (void)writeWord:(MOSWord)value toAddress:(MOSAbsoluteAddress)address {
    ((MOSWord *)self.data.mutableBytes)[address] = value;
}

- (void)loadBinaryImage:(NSData *)data {
    self.data = [NSMutableData dataWithLength:MOS_ADDRESS_SPACE_SIZE];
    [self.data replaceBytesInRange:NSMakeRange(0, data.length) withBytes:data.bytes];
}

@end