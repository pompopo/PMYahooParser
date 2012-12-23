//
// Created by pom on 12/12/24.
//
//


#import "PMYahooParser.h"

#define kYahooAPIBaseURL @"http://jlp.yahooapis.jp/MAService/V1/parse"

@implementation PMYahooParser {
    NSString *_appKey;
    NSMutableData *_data;
    void(^_block)(PMResult *);
    
    NSMutableArray *_tmpWordList;
    int _tmpTotalCount;
    int _tmpFilteredCount;
    int _tmpWord;
    NSString *_currentElement;
    PMResult *_result;
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
   completion:(void(^)(PMResult *))block {
    if (!_appKey || !aString || !block) {
        return;
    }
    _block = block;
    // TODO:正しくエンコードされないものがある
    NSString *encodedStr = [aString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"%@?appid=%@&sentence=%@", kYahooAPIBaseURL, _appKey, encodedStr];
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
    
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (_block) {
        _block(_result);
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    _currentElement = elementName;
    if ([elementName isEqualToString:@"ma_result"]) {
        _result = [[PMResult alloc] init];
    } else if ([elementName isEqualToString:@"word_list"]) {
        _tmpWordList = [NSMutableArray array];
    } else if ([elementName isEqualToString:@"word"]) {
        _word = [[PMWord alloc] init];
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"word_list"]) {
        _result.wordList = [NSArray arrayWithArray:_tmpWordList];
    } else if ([elementName isEqualToString:@"word"]) {
        [_tmpWordList addObject:_word];
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([_currentElement isEqualToString:@"total_count"]) {
        _result.totalCount = [string integerValue];
    } else if ([_currentElement isEqualToString:@"filtered_count"]) {
        _result.filteredCount = [string integerValue];
    } else if ([_currentElement isEqualToString:@"surface"]) {
        _word.surface = string;
    } else if ([_currentElement isEqualToString:@"reading"]) {
        _word.reading = string;
    } else if ([_currentElement isEqualToString:@"baseform"]) {
        _word.baseform = string;
    } else if ([_currentElement isEqualToString:@"pos"]) {
        _word.pos = string;
    } else if ([_currentElement isEqualToString:@"count"]) {
        _word.count = [string integerValue];
    }
}

@end