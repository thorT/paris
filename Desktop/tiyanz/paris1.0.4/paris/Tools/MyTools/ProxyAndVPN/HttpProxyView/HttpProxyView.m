//
//  HttpProxyView.m
//  paris
//
//  Created by thor on 2018/5/15.
//  Copyright © 2018年 paris. All rights reserved.
//

#import "HttpProxyView.h"
#import "Global.h"
#import "Const.h"
#import "Global_ui.h"
#import "Button_uLine.h"

@interface HttpProxyView()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *detail;

@end



@implementation HttpProxyView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)setIsVPN:(BOOL)isVPN{
    _isVPN = isVPN;
    if (isVPN) {
        self.title.text = @"VPN 关闭";
        self.detail.text = @"需要关闭VPN 才能使用";
    }
}

- (void)setIsHttpProxy:(BOOL)isHttpProxy{
    _isHttpProxy = isHttpProxy;
    if (isHttpProxy) {
        self.title.text = @"HTTP代理 关闭";
        self.detail.text = @"需要关闭HTTP代理 才能使用";
    }
}

- (void)initUI{
  //  self.backgroundColor = RGBCOLOR(49, 74, 129);
    // 背景图
    [Const gradientBg:self];
    
    CGFloat cornerRadius = AdaptedWidth(10);// 阴影圆角
    UIView *content = [[UIView alloc] init];
    content.frame = CGRectMake(0, 0, Screen_Width-2*AdaptedWidth(45),AdaptedHeight(525));
    content.backgroundColor = [UIColor whiteColor];
    content.clipsToBounds = YES;
    content.layer.cornerRadius = cornerRadius;
    
    // 创建阴影圆角
    UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(AdaptedWidth(45), AdaptedHeight(60), Screen_Width-2*AdaptedWidth(45),AdaptedHeight(525))];
    [self addSubview:shadowView];
    shadowView.layer.shadowColor = RGBCOLOR(253, 116, 75).CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    shadowView.layer.shadowOpacity = 0.6;
    shadowView.layer.shadowRadius = 8;
    shadowView.layer.cornerRadius = cornerRadius;
    shadowView.clipsToBounds = NO;
   [shadowView addSubview:content];
    {
        CGFloat w = CGRectGetWidth(content.frame);
        // top
        UIView *top = [[UIView alloc] init];
        top.frame = CGRectMake(0, 0, w,AdaptedHeight(65));
        [content addSubview:top];
        {
        UILabel *title = [[UILabel alloc] init];
        title.textColor = g_darkRed;
        title.frame = CGRectMake(0, AdaptedHeight(15),w , AdaptedHeight(25));
        title.font = AdaptedFontSizeBold(18);
        title.textAlignment = NSTextAlignmentCenter;
        [top addSubview:title];
        self.title = title;
        UILabel *detail = [[UILabel alloc] init];
        detail.textColor = g_grey;
        detail.textAlignment = NSTextAlignmentCenter;
        detail.font = AdaptedFontSize(14);
        detail.frame = CGRectMake(0, CGRectGetMaxY(title.frame), w, AdaptedHeight(20));
        [top addSubview:detail];
        self.detail = detail;
        }
        // center
        UIImageView *tip = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guanbi"]];
        CGFloat tip_y =  CGRectGetMaxY(top.frame)+AdaptedHeight(8);
        tip.frame = CGRectMake(w/2-AdaptedWidth(248)/2, tip_y, AdaptedWidth(248), AdaptedHeight(360));
        [content addSubview:tip];
        // bottom
        UIView *bottom = [[UIView alloc] init];
        bottom.frame = CGRectMake(-1, CGRectGetHeight(content.frame)-AdaptedHeight(90), w+2,AdaptedHeight(90)+2);
        bottom.backgroundColor = [UIColor whiteColor];
        [content addSubview:bottom];
        {
        UIButton *wifi = [[UIButton alloc] init];
        wifi.frame = CGRectMake(w/2-AdaptedWidth(225)/2,AdaptedHeight(16), AdaptedWidth(225), AdaptedHeight(35));
        [wifi setTitle:@"WIFI设置" forState:UIControlStateNormal];
        wifi.backgroundColor = g_darkRed;
        wifi.titleLabel.font = AdaptedFontSizeBold(15);
        wifi.layer.cornerRadius = AdaptedHeight(35)/2;
        wifi.clipsToBounds = YES;
        [wifi addTarget:self action:@selector(wifiAction) forControlEvents:UIControlEventTouchUpInside];
        [bottom addSubview:wifi];
        UIButton *vpn = [[UIButton alloc] init];
        vpn.frame = CGRectMake(w/2-AdaptedWidth(100)/2, AdaptedHeight(50), AdaptedWidth(100), AdaptedHeight(40));
        [vpn setTitleColor:RGBCOLOR(240, 59, 60) forState:UIControlStateNormal];
        [vpn setTitle:@"VPN设置" forState:UIControlStateNormal];
            vpn.titleLabel.font = AdaptedFontSizeBold(15);
        [vpn addTarget:self action:@selector(vpnAction) forControlEvents:UIControlEventTouchUpInside];
        [bottom addSubview:vpn];
        }
    }
    
    CGSize size = [Const sizeWithString:@"安装斗赚入口(推荐)" font:AdaptedFontSize(16) maxSize:CGSizeMake(MAXFLOAT, AdaptedHeight(28))];
    Button_uLine *Entrance = [[Button_uLine alloc] initWithFrame:CGRectMake(Screen_Width/2-size.width/2, Screen_Height-AdaptedHeight(60), size.width, AdaptedHeight(28))];
    Entrance.a_titleColor = [UIColor whiteColor] ;
    Entrance.a_titleText = @"安装斗赚入口(推荐)";
    Entrance.a_titleFont = AdaptedFontSize(16);
    Entrance.a_linebgColor = [UIColor whiteColor];
    [Entrance addTarget:self action:@selector(EntranceAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:Entrance];
    UIImageView *next = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_next"]];
    next.frame = CGRectMake(CGRectGetMaxX(Entrance.frame)+AdaptedWidth(3), CGRectGetMinY(Entrance.frame)+AdaptedHeight(7), AdaptedWidth(14), AdaptedHeight(14));
    [self addSubview:next];
}
- (void)wifiAction{
    NSURL *url = [NSURL URLWithString:@"App-prefs:root=WIFI"];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }else{
        [Const alertWith:@"请到\"设置-->wifi\"中关闭http代理"];
    }
}
- (void)vpnAction{
    NSURL *url = [NSURL URLWithString:@"App-prefs:root=General"];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }else{
        [Const alertWith:@"请到\"设置-->通用\"中关闭vpn"];
    }
}
- (void)EntranceAction{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://fenghanshangmao.com/laizhuan/entry.mobileconfig"]];
}

- (void)isVPN:(BOOL)isVPN isHttpProxy:(BOOL)isHttpProxy{
    if (isVPN || isHttpProxy) {
        self.hidden = NO;
    }
    
    if (isVPN && isHttpProxy) {
        self.title.text = @"VPN/HTTP代理 关闭";
        self.detail.text = @"需要关闭VPN与HTTP代理 才能使用";
    }else if(isVPN){
        self.title.text = @"VPN 关闭";
        self.detail.text = @"需要关闭VPN 才能使用";
    }else if(isHttpProxy){
        self.title.text = @"HTTP代理 关闭";
        self.detail.text = @"需要关闭HTTP代理 才能使用";
    }else{
        self.hidden = YES;
    }
}


@end












