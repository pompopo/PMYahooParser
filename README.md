PMYahooParser
=============

YAHOO! 日本語形態素解析API用ライブラリ

http://developer.yahoo.co.jp/webapi/jlp/ma/v1/parse.html を参照

    PMYahooParser *parser = [[PMYahooParser alloc] initWithKey:YOUR_APP_KEY];
    [parser parse:@"望遠鏡で泳ぐ彼女を見た。"
       completion:^(PMResult *result) {
           NSLog(@"total = %d, filtered = %d", result.totalCount, result.filteredCount);
           for (PMWord *word in result.wordList) {
               NSLog(@"surface = %@", word.surface);
               NSLog(@"reading = %@", word.reading);
               NSLog(@"pos = %@", word.pos);
               NSLog(@"baseform = %@", word.baseform);
               NSLog(@"count = %d", word.count);
           }
       }];
