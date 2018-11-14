//
//  Button_uLine.m
//  huitao
//
//  Created by thor on 2017/4/6.
//  Copyright © 2017年 thor. All rights reserved.
//

#import "Button_uLine.h"

@interface Button_uLine()

@property (nonatomic, strong) UILabel *a_title;

@property (nonatomic, strong) UIView *a_line;

@end


@implementation Button_uLine

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUnderlineWithFrame:frame];
    }
    return self;
}

- (void)addUnderlineWithFrame:(CGRect)frame{
    
    UILabel *title = [[UILabel alloc] init];
    [title adjustsFontSizeToFitWidth];
    title.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [self addSubview:title];
    self.a_title = title;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor grayColor];
    line.frame = CGRectMake(0,
                            0,
                            CGRectGetWidth(frame)-2,
                            1);
    line.bounds = CGRectMake(0,
                             0,
                             CGRectGetWidth(frame)-2,
                             1);
    line.center = CGPointMake(frame.size.width/2, frame.size.height-1);
    [self addSubview:line];
    self.a_line = line;
}


-(void)setA_titleText:(NSString *)a_titleText{
    self.a_title.text = a_titleText;
}

- (void)setA_titleFont:(UIFont *)a_titleFont{
    self.a_title.font = a_titleFont;
}

-(void)setA_titleColor:(UIColor *)a_titleColor{
    self.a_title.textColor = a_titleColor;
}

-(void)setA_titleAlignment:(NSTextAlignment)a_titleAlignment{
    self.a_title.textAlignment = a_titleAlignment;
}

- (void)setA_linebgColor:(UIColor *)a_linebgColor{
    self.a_line.backgroundColor = a_linebgColor;
}

- (void)setA_linebgWidth:(CGFloat)a_linebgWidth{
    CGRect rect = self.a_line.frame;
    CGPoint center = self.a_line.center;
    rect.size.width = a_linebgWidth;
    self.a_line.bounds = rect;
    self.a_line.center = center;
}


@end








