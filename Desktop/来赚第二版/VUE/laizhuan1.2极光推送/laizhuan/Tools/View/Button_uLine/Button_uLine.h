//
//  Button_uLine.h
//  huitao
//
//  Created by thor on 2017/4/6.
//  Copyright © 2017年 thor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Button_uLine : UIButton

@property (nonatomic, strong) NSString *a_titleText;

@property (nonatomic, strong) UIFont *a_titleFont;

@property (nonatomic, strong) UIColor *a_titleColor;

@property (nonatomic, assign) NSTextAlignment a_titleAlignment;

@property (nonatomic, strong) UIColor *a_linebgColor;

@property (nonatomic, assign) CGFloat a_linebgWidth;

@end
