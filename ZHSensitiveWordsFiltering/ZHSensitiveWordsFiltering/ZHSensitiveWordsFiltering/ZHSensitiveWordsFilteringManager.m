//
//  ZHSensitiveWordsFilteringManager.m
//  ZHSensitiveWordsFiltering
//
//  Created by 郑晗 on 2019/7/17.
//  Copyright © 2019 郑晗. All rights reserved.
//

#import "ZHSensitiveWordsFilteringManager.h"


#define EXIST @"isExists"

static NSString *words = @"微信，威信，维信，V信，微X，VX，weixin，加v，wx，+微，+V，+VX，wechat，QQ，qq，Qq，qQ，扣扣，+q，联系方式，手机号，微信号，qq号，电话号码，电话号";

@interface ZHSensitiveWordsFilteringManager()

@property (nonatomic ,copy)NSArray *filterArray;

@property (nonatomic,strong) NSMutableDictionary *root;

@property(nonatomic,strong)NSMutableArray *rootArray;

@property (nonatomic,assign) BOOL isFilterClose;

@end


@implementation ZHSensitiveWordsFilteringManager

+ (instancetype)shareInstance {
    static ZHSensitiveWordsFilteringManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [ZHSensitiveWordsFilteringManager new];
    });
    return manager;
}

- (NSArray *)filterArray
{
    if (!_filterArray) {
        NSArray *array = [words componentsSeparatedByString:@"，"];
        _filterArray = array;
    }
    return _filterArray;
}

//初始化过滤内容
- (void)initFilter{
    
    self.root = [NSMutableDictionary dictionary];
    
    self.rootArray = [NSMutableArray arrayWithArray:self.filterArray];
    
    for (NSString *str in self.rootArray) {
        //插入字符，构造节点
        [self insertWords:str];
    }
    
}
-(void)insertWords:(NSString *)words{
    NSMutableDictionary *node = self.root;
    
    for (int i = 0; i < words.length; i ++) {
        NSString *word = [words substringWithRange:NSMakeRange(i, 1)];
        
        if (node[word] == nil) {
            node[word] = [NSMutableDictionary dictionary];
        }
        
        node = node[word];
    }
    
    //敏感词最后一个字符标识
    node[EXIST] = [NSNumber numberWithInt:1];
}


#pragma mark-将文本中含有的敏感词进行替换
/*
 * 将文本中含有的敏感词进行替换
 *
 * @params str 文本字符串
 *
 * @return 过滤完敏感词之后的文本
 *
 */
- (NSString *)filter:(NSString *)str{
    
    if (self.isFilterClose || !self.root) {
        return str;
    }
    
    NSMutableString *result = result = [str mutableCopy];
    
    for (int i = 0; i < str.length; i ++) {
        NSString *subString = [str substringFromIndex:i];
        NSMutableDictionary *node = [self.root mutableCopy] ;
        int num = 0;
        
        for (int j = 0; j < subString.length; j ++) {
            NSString *word = [subString substringWithRange:NSMakeRange(j, 1)];
            
            if (node[word] == nil) {
                break;
            }else{
                num ++;
                node = node[word];
            }
            
            //敏感词匹配成功
            if ([node[EXIST]integerValue] == 1) {
                
                NSMutableString *symbolStr = [NSMutableString string];
                for (int k = 0; k < num; k ++) {
                    [symbolStr appendString:@"*"];
                }
                
                [result replaceCharactersInRange:NSMakeRange(i, num) withString:symbolStr];
                
                i += j;
                break;
            }
        }
    }
    
    return [self filterPhoneNumber:result];
}

/**
 过滤手机号
 
 @param string 需要过滤的字符串
 @return 返回过滤后的字符串
 */
- (NSString *)filterPhoneNumber:(NSString *)string
{
    NSString *parten = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9])\\d{8}$";
    NSError *error = nil;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:&error]; //options 根据自己需求选择
    
    NSArray *matches = [reg matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
    
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match range]; //获取所匹配的最长字符串
        
        NSMutableString *symbolStr = [NSMutableString string];
        for (int k = 0; k < matchRange.length; k ++) {
            [symbolStr appendString:@"*"];
        }
        string = [string stringByReplacingCharactersInRange:matchRange withString:symbolStr];
    }
    
    return string;
}
@end
