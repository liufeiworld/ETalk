//
//  CalendarLogic1.h
//  Calendar
//
//  Created by Neil on 14-7-3.
//  Copyright (c) 2014年 Neil. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "CalendarDayModel.h"
#import "NSDate+WQCalendarLogic.h"

@interface CalendarLogic : NSObject

- (NSMutableArray *)reloadCalendarView:(NSDate *)date  selectDate:(NSDate *)date1 needDays:(int)days_number;
- (void)selectLogic:(CalendarDayModel *)day;
@end
