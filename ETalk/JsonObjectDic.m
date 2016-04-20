//
//  JsonObjectDic.m
//  ETalk
//
//  Created by etalk365 on 16/1/8.
//  Copyright © 2016年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "JsonObjectDic.h"

@implementation JsonObjectDic

#pragma mark - 把格式化的JSON格式的字符串转换成字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark - 将字典组成json包
+ (NSString*)dictionaryToJson:(NSDictionary *)dic{
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
