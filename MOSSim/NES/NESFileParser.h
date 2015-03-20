//
// Copyright (c) 2015 Carmen Wick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NESFile;

@interface NESFileParser : NSObject
- (NESFile *)parseFile:(NSData *)data error:(NSError **)error;
@end
