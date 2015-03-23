//
// Copyright (c) 2015 Carmen Wick. All rights reserved.
//

#import "NESFileParser.h"
#import "MOSTypes.h"
#import "NESFile.h"

const uint32_t NES_MAGIC_NUMBER = 0x1A53454E;

typedef struct {
    uint32_t magicNumber;
    uint8_t prgRomSize; // In 16KB units
    uint8_t chrRomSize; // In 8KB units
    uint8_t flags6;
    uint8_t flags7;
} NESHeader;

@implementation NESFileParser {

}

- (NESFile *)parseFile:(NSData *)data error:(NSError **)error {
    NESHeader *header = (NESHeader *)data.bytes;
    NESFile *file = [NESFile new];

    if (!header || header->magicNumber != NES_MAGIC_NUMBER) {
        *error = [NSError errorWithDomain:@"NESFileParsingError" code:0 userInfo:nil];
        return nil;
    }

    file.prgRomSize = header->prgRomSize;
    file.chrRomSize = header->chrRomSize;
    file.mapper = [self parseMapperNumber:header];

    return file;
}

- (int)parseMapperNumber:(NESHeader *)header {
    MOSWord mapperUpper = (MOSWord) (header->flags7 & 0xF0);
    MOSWord mapperLower = (MOSWord) ((header->flags6 & 0xF0) >> 4);

    return mapperUpper | mapperLower;
}

@end