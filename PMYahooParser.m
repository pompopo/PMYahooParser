//
// Created by pom on 12/12/24.
//
//


#import "PMYahooParser.h"

#define kYahooAPIBaseURL @"http://jlp.yahooapis.jp/MAService/V1/parse"
#define kResultTypeMa 1
#define kResultTypeUniq 2

@implementation PMYahooParser {
    NSString *_appKey;
    NSMutableData *_data;
    void(^_block)(PMResultSet *);
    
    NSMutableArray *_tmpWordList;
    int _tmpTotalCount;
    int _tmpFilteredCount;
    int _tmpWord;
    NSString *_currentElement;
    PMResultSet *_resultSet;
    int _currentResult;
    PMWord *_word;
}

- (id)initWithKey:(NSString *)appKey {
    self = [super init];
    if (self) {
        _appKey = appKey;
    }
    return self;
}

- (void)parse:(NSString *)aString
   completion:(void(^)(PMResultSet *))block {
    if (!_appKey || !aString || !block) {
        return;
    }

    _block = block;
    
    // results parameter
    NSString *resultParam = @"";
    if (_results > 0) {
        NSMutableString *tmpResultParam = [NSMutableString string];
        if (_results & PMResultMa) {
            [tmpResultParam appendString:@",ma"];
        }
        if (_results & PMResultUniq) {
            [tmpResultParam appendString:@",uniq"];
        }
        if (tmpResultParam.length > 0) {
            resultParam = [NSString stringWithFormat:@"&results=%@", [tmpResultParam substringFromIndex:1]];
        }
    }
    
    // response parameter
    NSString *responseParam = @"";
    if (_response > 0) {
        NSMutableString *tmpResponseParam = [NSMutableString string];
        if (_response & PMResponseSurface) {
            [tmpResponseParam appendString:@",surface"];
        }
        if (_response & PMResponseReading) {
            [tmpResponseParam appendString:@",reading"];
        }
        if (_response & PMResponsePos) {
            [tmpResponseParam appendString:@",pos"];
        }
        if (_response & PMResponseBaseform) {
            [tmpResponseParam appendString:@",baseform"];
        }
        if (_response & PMResponseFeature) {
            [tmpResponseParam appendString:@",feature"];
        }
        if (tmpResponseParam.length > 0) {
            responseParam = [NSString stringWithFormat:@"&response=%@", [tmpResponseParam substringFromIndex:1]];
        }
    }

    
    // filter parameter
    NSString *filterParam = @"";
    if (_filter > 0) {
        NSMutableString *tmpFilterParam = [NSMutableString string];
        if (_filter & PMFilterAdjective) {
            [tmpFilterParam appendString:@"|1"];
        }
        if (_filter & PMFilterAdjectivalNoun) {
            [tmpFilterParam appendString:@"|2"];
        }
        if (_filter & PMFilterInterjection) {
            [tmpFilterParam appendString:@"|3"];
        }
        if (_filter & PMFilterAdverb) {
            [tmpFilterParam appendString:@"|4"];
        }
        if (_filter & PMFilterAdnominalAdjective) {
            [tmpFilterParam appendString:@"|5"];
        }
        if (_filter & PMFilterConjunction) {
            [tmpFilterParam appendString:@"|6"];
        }
        if (_filter & PMFilterSuffix) {
            [tmpFilterParam appendString:@"|7"];
        }
        if (_filter & PMFilterPrefix) {
            [tmpFilterParam appendString:@"|8"];
        }
        if (_filter & PMFilterNoun) {
            [tmpFilterParam appendString:@"|9"];
        }
        if (_filter & PMFilterVerb) {
            [tmpFilterParam appendString:@"|10"];
        }
        if (_filter & PMFilterParticle) {
            [tmpFilterParam appendString:@"|11"];
        }
        if (_filter & PMFilterAuxiliaryVerb) {
            [tmpFilterParam appendString:@"|12"];
        }
        if (_filter & PMFilterSpecial) {
            [tmpFilterParam appendString:@"|13"];
        }
        if (tmpFilterParam.length > 0) {
            filterParam = [NSString stringWithFormat:@"&filter=%@", [tmpFilterParam substringFromIndex:1]];
        }
    }
    // TODO:正しくエンコードされないものがある
    NSString *urlStr = [[NSString stringWithFormat:@"%@?appid=%@&sentence=%@%@%@%@", kYahooAPIBaseURL, _appKey, aString, resultParam, responseParam, filterParam] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request
                                  delegate:self];    
}
/////////////////// private methods

#pragma mark -
#pragma mark NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (! _data) {
        _data = [[NSMutableData alloc] init];
    }

    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (_data) {
        NSLog(@"DATA = %@",[[NSString alloc] initWithData:_data
                                                 encoding:NSUTF8StringEncoding]);
        NSData *data = [NSData dataWithData:_data];
        NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
        parser.delegate = self;
        [parser parse];
        _data = nil;
    }
}
#pragma mark -
#pragma mark NSXMLParserDelegate
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    _resultSet = [[PMResultSet alloc] init];
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (_block) {
        _block(_resultSet);
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    _currentElement = elementName;
    if ([elementName isEqualToString:@"ma_result"]) {
        _resultSet.maResult = [[PMResult alloc] init];
        _currentResult = kResultTypeMa;
    } else if ([elementName isEqualToString:@"uniq_result"]) {
        _resultSet.uniqResult = [[PMResult alloc] init];
        _currentResult = kResultTypeUniq;
    } else if ([elementName isEqualToString:@"word_list"]) {
        _tmpWordList = [NSMutableArray array];
    } else if ([elementName isEqualToString:@"word"]) {
        _word = [[PMWord alloc] init];
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"word_list"]) {
        if (_currentResult == kResultTypeMa) {
            _resultSet.maResult.wordList = [NSArray arrayWithArray:_tmpWordList];
        } else {
            _resultSet.uniqResult.wordList = [NSArray arrayWithArray:_tmpWordList];
        }
    } else if ([elementName isEqualToString:@"word"]) {
        [_tmpWordList addObject:_word];
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([_currentElement isEqualToString:@"total_count"]) {
        if (_currentResult == kResultTypeMa) {
            _resultSet.maResult.totalCount = [string integerValue];
        } else {
            _resultSet.uniqResult.totalCount = [string integerValue];
        }
    } else if ([_currentElement isEqualToString:@"filtered_count"]) {
        if (_currentResult == kResultTypeMa) {
            _resultSet.maResult.filteredCount = [string integerValue];
        } else {
            _resultSet.uniqResult.filteredCount = [string integerValue];
        }
    } else if ([_currentElement isEqualToString:@"surface"]) {
        _word.surface = string;
    } else if ([_currentElement isEqualToString:@"reading"]) {
        _word.reading = string;
    } else if ([_currentElement isEqualToString:@"baseform"]) {
        _word.baseform = string;
    } else if ([_currentElement isEqualToString:@"pos"]) {
        _word.pos = string;
    } else if ([_currentElement isEqualToString:@"feature"]) {
        _word.feature = string;
    } else if ([_currentElement isEqualToString:@"count"]) {
        _word.count = [string integerValue];
    }
}

@end