PMYahooParser
=============

YAHOO! 日本語形態素解析API用ライブラリ

http://developer.yahoo.co.jp/webapi/jlp/ma/v1/parse.html を参照

    PMYahooParser *parser = [[PMYahooParser alloc] initWithKey:kMyAppKey];
    parser.response = PMResponseSurface;
    parser.filter = PMFilterNoun | PMFilterVerb;

    [parser parse:@"望遠鏡で泳いでいる少女を観る"
       completion:^(PMResultSet *resultSet) {
           NSLog(@"total = %d, filtered = %d", resultSet.maResult.totalCount, resultSet.maResult.filteredCount);
           for (PMWord *word in resultSet.maResult.wordList) {
               NSLog(@"surface = %@", word.surface);
               NSLog(@"reading = %@", word.reading);
               NSLog(@"pos = %@", word.pos);
               NSLog(@"baseform = %@", word.baseform);
               NSLog(@"count = %d", word.count);
           }
       }];
