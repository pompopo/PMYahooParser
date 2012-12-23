//
//  PMResult.h
//  PMYahooParser
//
//  Created by pom on 12/12/24.
//
//

#import <Foundation/Foundation.h>
@class PMWord;

@interface PMResult : NSObject
// 形態素の総数を返します。
@property (nonatomic) int totalCount;

// フィルタにマッチした形態素数を返します。
@property (nonatomic) int filteredCount;

// 形態素のリストを返します。
@property (nonatomic, retain) NSArray *wordList;
@end
