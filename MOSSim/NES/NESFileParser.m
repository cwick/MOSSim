//
// Copyright (c) 2015 Carmen Wick. All rights reserved.
//

#import "NESFileParser.h"
#import "MOSTypes.h"
#import "NESFile.h"

const uint64 NES_MAGIC_NUMBER = 0x1A53454E;

typedef struct {
    uint64 magicNumber;
} NESHeader;

@implementation NESFileParser {

}

- (NESFile *)parseFile:(NSData *)data error:(NSError **)error {
    NESHeader *header = (NESHeader *)data.bytes;
    if (!header || header->magicNumber != NES_MAGIC_NUMBER) {
        *error = [NSError errorWithDomain:@"NESFileParsingError" code:0 userInfo:nil];
        return nil;
    }

    return nil;
}

@end