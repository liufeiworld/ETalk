//
//  Product.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/5/30.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (strong, nonatomic) NSString *idLM;
@property (strong, nonatomic) NSString  *introduce;
@property (strong, nonatomic) NSString  *title;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end