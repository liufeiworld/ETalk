//
//  CourseListModel.m
//  ETalk
//
//  Created by etalk365 on 16/2/2.
//  Copyright © 2016年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "CourseListModel.h"

@implementation CourseListModel

#pragma mark - setValue: forKey
/*
 3.过滤NSNumber类型
 */
//重写setValue:forKey:
-(void)setValue:(id)value forKey:(NSString *)key{
    //过滤NSNumber类型
    if ([value isKindOfClass:[NSNumber class]]) {
        
        //格式化成为字符串
        [self setValue:[NSString stringWithFormat:@"%@",value] forKey:key];
        
    }
    else if([value isKindOfClass:[NSNull class]])
    {
        [self setValue:[NSString stringWithFormat:@"%@",value] forKey:key];
    }
    else{
        [super setValue:value forKey:key];
    }
    
    
}

/*
 1. 防止服务器擅自加字段而又未通知我们造成的程序崩溃
 2.防止出现一些OC中不能声明的字段名
 */
//重写该方法防止崩溃
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    //判断如果字段名为id,则把id对应的value值赋给userId
    if ([key isEqualToString:@"id"]) {
        
        [self setValue:value forKey:@"myid"];
        
    }else{
        
        //NSLog(@"未定找到对应的key值:%@",key);
    }
}
//用数据库的时候要重写这个方法
-(void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues{
    
    for (NSString *key in keyedValues) {
        
        [self setValue:keyedValues[key] forKey:key];
        
    }
    
}

- (id)valueForUndefinedKey:(NSString *)key{
    
    return nil;
}

- (id)initWithDictionary:(NSDictionary *)dic{

    self = [super init];
    if (self) {
        _teaEvaluat = [dic objectForKey:kRespondKeyTeaEvaluat];
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"teaEvaluat = %@",_teaEvaluat];
    
}

@end
