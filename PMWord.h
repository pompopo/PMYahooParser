//
//  PMWord.h
//  PMYahooParser
//
//  Created by pom on 12/12/24.
//
//

#import <Foundation/Foundation.h>

@interface PMWord : NSObject
// 形態素の表記を返します。
@property (nonatomic, copy) NSString *surface;

// 形態素の読みがなを返します。
@property (nonatomic, copy) NSString *reading;

// 形態素の品詞を返します。
@property (nonatomic, copy) NSString *pos;

// 形態素の基本形表記を返します。活用のない形態素の場合は省略されます。
@property (nonatomic, copy) NSString *baseform;

// 形態素の全情報を文字列で返します。
@property (nonatomic, copy) NSString *feature;

// uniq_result 中の word 内に現れる、形態素の出現数を返します。
@property (nonatomic) int count;
@end
