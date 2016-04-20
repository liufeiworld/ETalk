//
//  UIPlaceHolderTextView.h
//  dsPlayer
//
//  Created by Neil on 13-12-10.
//  Copyright (c) 2013年 PreVideo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end