//
//  NSString+ZHFilter.h
//  ZHSensitiveWordsFiltering
//
//  Created by 郑晗 on 2019/7/17.
//  Copyright © 2019 郑晗. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZHFilter)

//过滤敏感词
+(NSString *)filterSensitiveWords:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
