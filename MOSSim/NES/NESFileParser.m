//
// Copyright (c) 2015 Carmen Wick. All rights reserved.
//

#import "NESFileParser.h"
#import "MOSTypes.h"
#import "NESFile.h"

@implementation NESFileParser {

}

- (NESFile *)parseFile:(NSData *)data error:(NSError **)error {
    *error = [NSError errorWithDomain:@"NESFileParsingError" code:0 userInfo:nil];
    return nil;
}

@end