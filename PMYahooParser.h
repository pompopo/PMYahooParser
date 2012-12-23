//
// Created by pom on 12/12/24.
//
//


#import <Foundation/Foundation.h>
#import "PMResult.h"
#import "PMWord.h"

@interface PMYahooParser : NSObject <NSURLConnectionDataDelegate, NSXMLParserDelegate>


- (id)initWithKey:(NSString *)appKey;
- (void)parse:(NSString *)aString
   completion:(void(^)(PMResult *))block;
@end