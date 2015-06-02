//
// Copyright (c) 2015 Carmen Wick. All rights reserved.
//

#import "MOSTypes.h"

@interface NESFile : NSObject

@property(nonatomic) MOSWord prgRomSize;
@property(nonatomic) MOSWord prgRamSize;
@property(nonatomic) MOSWord chrRomSize;
@property(nonatomic) int mapper;

@end