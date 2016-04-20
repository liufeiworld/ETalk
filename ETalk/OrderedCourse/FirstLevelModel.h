//
//  FirstLevelModel.h
//  ETalk
//
//  Created by etalk365 on 15/9/9.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirstLevelModel : NSObject

@property (assign, nonatomic) int firstId;
@property (strong, nonatomic) NSString *firstIntroduce;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSArray *secondListArray;


#if 0
{
    firstId = 1;
    firstIntroduce = "\U56fd\U5185\U9996\U5bb6\U7ed3\U5408\U5b66\U6821\U4e5d\U5e74\U5236\U4e49\U52a1\U6559\U80b2\U82f1\U8bed\U8bfe\U672c\Uff0c\U91c7\U7528\U5916\U6559\U4e00\U5bf9\U4e00\U6a21\U5f0f\U8fdb\U884c\U5728\U7ebf\U6388\U8bfe\U7684\U6559\U5b66\U6a21\U5f0f\U3002\U9488\U5bf9\U5b66\U6821\U5927\U8bfe\U5802\U4e00\U4e2a\U82f1\U8bed\U8001\U5e08\U5bf950\U4e2a\U5b69\U5b50\U7684\U73b0\U72b6\Uff0c\U5b69\U5b50\U7f3a\U5c11\U5f00\U53e3\U7ec3\U4e60\U7684\U673a\U4f1a\Uff0c\U800c\U8001\U5e08\U4e5f\U65e0\U6cd5\U9010\U4e00\U8fdb\U884c\U7ea0\U6b63\U548c\U8f85\U5bfc\U3002\U62a5\U8bfb\U6b64\U5957\U9910\Uff0c\U76f8\U5f53\U4e8e\U6bcf\U5468\U8bf7\U5916\U6559\U4e00\U5bf9\U4e00\U4e0a\U95e8\U8f85\U5bfc3-4\U6b21\Uff0c\U6bcf\U6b2117\U5206\U949f\U4e2a\U6027\U5316\U8bfe\U672c\U7b54\U7591\U548c\U53e5\U5b50\U8bcd\U6c47\U6f14\U7ec3\U3001\U53d1\U97f3\U7ea0\U6b63\Uff0c\U5e2e\U52a9\U4f60\U7684\U5b69\U5b50\U771f\U6b63\U5b66\U4ee5\U81f4\U7528\Uff0c\U63d0\U5347\U82f1\U8bed\U5b66\U4e60\U5174\U8da3\U7684\U540c\U65f6\U63d0\U9ad8\U82f1\U8bed\U6210\U7ee9\U3002
    \n";
    firstName = "\U9752\U5c11\U5e74\U82f1\U8bed";
    secondList =             (
                              {
                                  packageList =                     (
                                                                     {
                                                                         everydayClass = 0;
                                                                         packageId = 23;
                                                                         packageLessonCount = 30;
                                                                         packageName = "30\U8bfe\U65f6";
                                                                         packagePrice = 600;
                                                                         packageValid = 30;
                                                                     },
                                                                     {
                                                                         everydayClass = 0;
                                                                         packageId = 24;
                                                                         packageLessonCount = 180;
                                                                         packageName = "180\U8bfe\U65f6";
                                                                         packagePrice = 3240;
                                                                         packageValid = 180;
                                                                     },
                                                                     {
                                                                         everydayClass = 0;
                                                                         packageId = 25;
                                                                         packageLessonCount = 360;
                                                                         packageName = "360\U8bfe\U65f6";
                                                                         packagePrice = 5400;
                                                                         packageValid = 360;
                                                                     },
                                                                     {
                                                                         everydayClass = 0;
                                                                         packageId = 26;
                                                                         packageLessonCount = 720;
                                                                         packageName = "720\U8bfe\U65f6";
                                                                         packagePrice = 7200;
                                                                         packageValid = 720;
                                                                     },
                                                                     {
                                                                         everydayClass = 0;
                                                                         packageId = 27;
                                                                         packageLessonCount = 1440;
                                                                         packageName = "1440\U8bfe\U65f6";
                                                                         packagePrice = 9792;
                                                                         packageValid = 720;
                                                                     }
                                                                     );
                                  secondId = 2;
                                  secondIntroduce = "\U5168\U90e8\U8bfe\U7a0b\U7531\U767d\U94f6\U7ea7\U8001\U5e08\U6388\U8bfe\Uff0c\U8bfe\U7a0b\U6709\U6548\U671f\U8f83\U77ed\Uff0c\U5efa\U8bae\U6bcf\U59291-2\U8bfe";
                                  secondName = "\U767d\U94f6\U5957\U9910";
                              },
                              {
                                  packageList =                     (
                                                                     {
                                                                         everydayClass = 0;
                                                                         packageId = 28;
                                                                         packageLessonCount = 30;
                                                                         packageName = "30\U8bfe\U65f6";
                                                                         packagePrice = 900;
                                                                         packageValid = 60;
                                                                     },
                                                                     {
                                                                         everydayClass = 0;
                                                                         packageId = 29;
                                                                         packageLessonCount = 180;
                                                                         packageName = "180\U8bfe\U65f6";
                                                                         packagePrice = 4500;
                                                                         packageValid = 360;
                                                                     },
                                                                     {
                                                                         everydayClass = 0;
                                                                         packageId = 30;
                                                                         packageLessonCount = 360;
                                                                         packageName = "360\U8bfe\U65f6";
                                                                         packagePrice = 7200;
                                                                         packageValid = 720;
                                                                     },
                                                                     {
                                                                         everydayClass = 0;
                                                                         packageId = 31;
                                                                         packageLessonCount = 720;
                                                                         packageName = "720\U8bfe\U65f6";
                                                                         packagePrice = 12960;
                                                                         packageValid = 1440;
                                                                     }
                                                                     );
                                  secondId = 3;
                                  secondIntroduce = "\U5168\U90e8\U8bfe\U7a0b\U7531\U94c2\U91d1\U7ea7\U8001\U5e08\U6388\U8bfe\Uff0c\U8bfe\U7a0b\U6709\U6548\U671f\U8f83\U957f\Uff0c\U5efa\U8bae\U6bcf\U54683-4\U8bfe";
                                  secondName = "\U94c2\U91d1\U5957\U9910";
                              },
                              {
                                  packageList =                     (
                                                                     {
                                                                         everydayClass = 0;
                                                                         packageId = 32;
                                                                         packageLessonCount = 15;
                                                                         packageName = "15\U8bfe\U65f6";
                                                                         packagePrice = 750;
                                                                         packageValid = 0;
                                                                     },
                                                                     {
                                                                         everydayClass = 0;
                                                                         packageId = 33;
                                                                         packageLessonCount = 90;
                                                                         packageName = "90\U8bfe\U65f6";
                                                                         packagePrice = 3600;
                                                                         packageValid = 0;
                                                                     },
                                                                     {
                                                                         everydayClass = 0;
                                                                         packageId = 34;
                                                                         packageLessonCount = 180;
                                                                         packageName = "180\U8bfe\U65f6";
                                                                         packagePrice = 6300;
                                                                         packageValid = 0;
                                                                     },
                                                                     {
                                                                         everydayClass = 0;
                                                                         packageId = 35;
                                                                         packageLessonCount = 360;
                                                                         packageName = "360\U8bfe\U65f6";
                                                                         packagePrice = 10800;
                                                                         packageValid = 0;
                                                                     },
                                                                     {
                                                                         everydayClass = 0;
                                                                         packageId = 36;
                                                                         packageLessonCount = 720;
                                                                         packageName = "720\U8bfe\U65f6";
                                                                         packagePrice = 18000;
                                                                         packageValid = 0;
                                                                     }
                                                                     );
                                  secondId = 4;
                                  secondIntroduce = "\U5168\U90e8\U8bfe\U7a0b\U7531\U94bb\U77f3\U7ea7\U8001\U5e08\U6388\U8bfe\Uff0c\U6ca1\U6709\U8bfe\U7a0b\U6709\U6548\U671f\U9650\U5236\Uff0c\U6700\U7075\U6d3b\U5957\U9910";
                                  secondName = "\U94bb\U77f3\U5957\U9910";
                              }
                              );
},
#endif

@end
