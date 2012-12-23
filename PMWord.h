//
//  PMWord.h
//  PMYahooParser
//
//  Created by pom on 12/12/24.
//
//

#import <Foundation/Foundation.h>

@interface PMWord : NSObject
@property (nonatomic, copy) NSString *surface;
@property (nonatomic, copy) NSString *reading;
@property (nonatomic, copy) NSString *pos;
@property (nonatomic, copy) NSString *baseform;
@property (nonatomic) int count;
@end
