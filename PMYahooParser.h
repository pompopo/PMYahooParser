//
// Created by pom on 12/12/24.
//
//


#import <Foundation/Foundation.h>
#import "PMResult.h"
#import "PMWord.h"
#import "PMResultSet.h"
@interface PMYahooParser : NSObject <NSURLConnectionDataDelegate, NSXMLParserDelegate>


- (id)initWithKey:(NSString *)appKey;
- (void)parse:(NSString *)aString
   completion:(void(^)(PMResultSet *))block;
@property (nonatomic) int results;
@property (nonatomic) int response;
@property (nonatomic) unsigned long filter;
@property (nonatomic) int maResponse;
@property (nonatomic) unsigned long maFilter;
@property (nonatomic) int uniqResponse;
@property (nonatomic) unsigned long uniqFilter;


enum {
    PMResultMa = 1 << 0,
    PMResultUniq = 1 << 1,
};
enum {
    PMResponseSurface = 1 << 0,
    PMResponseReading = 1 << 1,
    PMResponsePos = 1 << 2,
    PMResponseBaseform = 1 << 3,
    PMResponseFeature = 1 << 4,
};

enum {
    // 1 : 形容詞
    PMFilterAdjective = 1UL << 0,
    // 2 : 形容動詞
    PMFilterAdjectivalNoun = 1UL << 1,
    // 3 : 感動詞
    PMFilterInterjection = 1UL << 2,
    // 4 : 副詞
    PMFilterAdverb = 1UL << 3,
    // 5 : 連体詞
    PMFilterAdnominalAdjective = 1UL << 4,
    // 6 : 接続詞
    PMFilterConjunction = 1UL << 5,
    // 7 : 接頭辞
    PMFilterPrefix = 1UL << 6,
    // 8 : 接尾辞
    PMFilterSuffix = 1UL << 7,
    // 9 : 名詞
    PMFilterNoun = 1UL << 8,
    // 10 : 動詞
    PMFilterVerb = 1UL << 9,
    // 11 : 助詞
    PMFilterParticle = 1UL << 10,
    // 12 : 助動詞
    PMFilterAuxiliaryVerb = 1UL << 11,
    // 13 : 特殊（句読点、カッコ、記号など）
    PMFilterSpecial = 1UL << 12,
};
@end