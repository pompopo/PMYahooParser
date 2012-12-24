//
//  PMResultSet.h
//  PMYahooParser
//
//  Created by pom on 12/12/24.
//
//

#import <Foundation/Foundation.h>
@class PMResult;

@interface PMResultSet : NSObject
@property (nonatomic, retain) PMResult *maResult;
@property (nonatomic, retain) PMResult *uniqResult;
@end
