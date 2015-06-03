//
// Copyright (c) 2015 Carmen Wick. All rights reserved.
//

#import "MOSDevice.h"

// http://wiki.nesdev.com/w/index.php/NROM
@interface NESNROMCartridge : NSObject<MOSDevice>
@property (nonatomic, strong) NSData *romBank0;
@property (nonatomic, strong) NSData *romBank1;
@end