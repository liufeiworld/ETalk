//
//  CalendarHomeViewController.h
//  Calendar
//
//  Created by Neil on 14-6-23.
//  Copyright (c) 2014年 Neil. All rights reserved.
//



#import <UIKit/UIKit.h>


@interface ClassBookingViewController : UIViewController

@property (strong, nonatomic) NSString *productID;
@property (strong, nonatomic) NSString *productLM;
@property (strong, nonatomic) NSString *wTime;

@property (strong, nonatomic) NSString *orderId;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *orderAlertView;
@property (weak, nonatomic) IBOutlet UILabel *orderDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;

- (IBAction)commitOrder:(id)sender;
- (IBAction)cancelOrder:(id)sender;

@end
