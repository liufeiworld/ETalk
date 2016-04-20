//
//  Product.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/5/30.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "Product.h"

@implementation Product

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _idLM = [dictionary objectForKey:@"id_lm"];
        _introduce = [dictionary objectForKey:@"introduce"];
        _title = [dictionary objectForKey:@"title_lm"];
    }
    
    return self;
}

@end
