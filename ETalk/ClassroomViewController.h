//
//  ClassroomViewController.h
//  ETalk
//
//  Created by etalk365 on 15/12/25.
//  Copyright © 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^MyBlock) () ;
@interface ClassroomViewController : UIViewController

@property (strong, nonatomic) NSString *msgCount;
@property (nonatomic,copy)MyBlock block;
@end
