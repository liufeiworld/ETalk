//
//  CourseListModel.h
//  ETalk
//
//  Created by etalk365 on 16/2/2.
//  Copyright © 2016年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseListModel : NSObject

@property (nonatomic,strong)NSString *myid;
@property (nonatomic,strong)NSString *materials;
@property (nonatomic,strong)NSString *packageName;
@property (nonatomic,strong)NSString *period;
@property (nonatomic,strong)NSString *stuComment;
@property (nonatomic,strong)NSString *stuScore;
@property (nonatomic,strong)NSString *teaEvaluat;
@property (nonatomic,strong)NSString *teacher;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
