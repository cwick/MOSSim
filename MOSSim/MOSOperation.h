#import <Foundation/Foundation.h>

@class MOSCPU;

@protocol MOSOperation <NSObject>

- (void)execute:(MOSCPU *)cpu;

@end
