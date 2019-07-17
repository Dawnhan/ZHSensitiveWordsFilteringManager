//
//  ZHSensitiveWordsFilteringManager.h
//  ZHSensitiveWordsFiltering
//
//  Created by 郑晗 on 2019/7/17.
//  Copyright © 2019 郑晗. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHSensitiveWordsFilteringManager : NSObject

+ (instancetype)shareInstance;


/**
 初始化敏感词汇 */
- (void)initFilter;

/*
 * 将文本中含有的敏感词进行替换
 *
 * @params str 文本字符串
 *
 * @return 过滤完敏感词之后的文本
 *
 */
- (NSString *)filter:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
