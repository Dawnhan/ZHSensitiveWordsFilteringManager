//
//  NSString+ZHFilter.m
//  ZHSensitiveWordsFiltering
//
//  Created by 郑晗 on 2019/7/17.
//  Copyright © 2019 郑晗. All rights reserved.
//

#import "NSString+ZHFilter.h"
#import "ZHSensitiveWordsFilteringManager.h"
@implementation NSString (ZHFilter)

//过滤敏感词
+(NSString *)filterSensitiveWords:(NSString *)string;
{
    return [[ZHSensitiveWordsFilteringManager shareInstance]filter:string];
}

@end
