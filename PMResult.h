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
@property (nonatomic) int totalCount;
@property (nonatomic) int filteredCount;
@property (nonatomic, retain) NSArray *wordList;
@end
