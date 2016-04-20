//
//  AnswerViewController.h
//  ETalk
//
//  Created by etalk365 on 15/12/24.
//  Copyright © 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncUdpSocket.h"
#import "ChatCustomCell.h"
#import <QuartzCore/QuartzCore.h>

@interface AnswerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
- (IBAction)sendMessage_Click:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *myView;

@property (strong, nonatomic) NSString * titleString;
@property (strong, nonatomic) NSString *messageString;
@property (strong, nonatomic) NSString *phraseString;
@property (strong, nonatomic) NSMutableArray *chatArray;
@property (nonatomic,assign) BOOL isFromNewSMS;
@property (strong, nonatomic) AsyncUdpSocket *udpSocket;
@property (strong, nonatomic) NSDate *lastTime;

@property (strong, nonatomic) NSString * receiveString;
@property (strong, nonatomic) NSMutableData * receiveData;
@property (strong, nonatomic) NSString * sendString;
@property (strong, nonatomic) NSMutableData *sendData;

-(void)openUDPServer;
-(void)sendMassage:(NSString *)message;
-(void)deleteContentFromTableView;

- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf;

-(void)getImageRange:(NSString*)message : (NSMutableArray*)array;
-(UIView *)assembleMessageAtIndex : (NSString *) message from: (BOOL)fromself;

@end
