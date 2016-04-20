//
//  JsonObjectDic.h
//  ETalk
//
//  Created by etalk365 on 16/1/8.
//  Copyright © 2016年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonObjectDic : NSObject

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

@end
