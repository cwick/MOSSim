//
// Copyright (c) 2015 Carmen Wick. All rights reserved.
//

#import "MOSDevice.h"

// http://wiki.nesdev.com/w/index.php/NROM
@interface NESNROMCartridge : NSObject<MOSDevice>

+ (NESNROMCartridge *)cartridgeWithRomBank0:(NSData *)bank0 andRomBank1:(NSData *)bank1;

@property (nonatomic, strong) NSData *romBank0;
@property (nonatomic, strong) NSData *romBank1;

@end