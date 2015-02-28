#import "MOSFakeDataStream.h"

@implementation MOSFakeDataStream

- (MOSWord)nextWord {
    NSNumber *next = self.data[self.location++];
    return [next unsignedCharValue];
}

- (void)setData:(NSArray *)data {
    _data = data;
    self.location = 0;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _data = @[];
        _location = 0;
    }
    
    return self;
}

@end
