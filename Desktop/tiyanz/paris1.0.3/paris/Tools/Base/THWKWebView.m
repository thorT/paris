//
//  THWebView.m
//  laizhuanJP
//
//  Created by thor on 2016/10/21.
//  Copyright © 2016年 thor. All rights reserved.
//

#import "THWKWebView.h"
#import "Global_ui.h"
#import "Global.h"
#import "DGActivityIndicatorView.h"


@interface THWKWebView()

//@property (nonatomic, strong) UIButton *reloadButton;

@property (nonatomic, strong)DGActivityIndicatorView *indicator;

@property (nonatomic, strong)UIView *reloadView;

@property (nonatomic, assign) BOOL isPost;

@property (nonatomic, strong) NSString *webUrl;

@property (nonatomic, strong) UIButton * close;

@end

@implementation THWKWebView

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - 加载
- (UIButton *)close{
    if (!_close) {
        UIButton * close = [[UIButton alloc] init];
        close.frame = CGRectMake(Screen_Width-44, 30, 25, 25);
        UIImage * bImage = [UIImage imageNamed:@"idcard_back"];
        [close addTarget: self action: @selector(rightBarButtonClick)forControlEvents: UIControlEventTouchUpInside];
        [close setImage: bImage forState: UIControlStateNormal];
        [self addSubview:close];
        _close = close;
        //close.backgroundColor = [UIColor redColor];
    }
    return _close;
}

- (DGActivityIndicatorView *)indicator{
    if (!_indicator) {
        _indicator = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeCookieTerminator tintColor:g_theme];
        CGFloat width = Screen_Width / 5.0f;
        CGFloat height = Screen_Height / 7.0f;
        
        _indicator.frame = CGRectMake(Screen_Width/2-width/2, Screen_Height/2-height/2, width, height);
        [self addSubview:_indicator];
    }
    return _indicator;
}

- (UIView*)reloadView {
    if (!_reloadView) {
        UIView *view = [[UIView alloc] init];
        view.bounds = CGRectMake(0, 0, AdaptedWidth(320), AdaptedHeight(410));
        view.center = self.center;
        _reloadView = view;
        [self addSubview:view];
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(CGRectGetWidth(view.frame)/2-AdaptedWidth(200)/2, 0, AdaptedWidth(208), AdaptedWidth(206));
            imageView.image = [UIImage imageNamed:@"singel"];
            [view addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(0,CGRectGetMaxY(imageView.frame)+AdaptedWidth(15), CGRectGetWidth(view.frame), AdaptedHeight(50));
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont fontWithName:@"Heiti SC" size:17];
            label.text = @"没有信号了哦~";
            [view addSubview:label];
            
            UIButton *btn = [[UIButton alloc] init];
            [btn setTitle:@"重试" forState:UIControlStateNormal];
            [btn setTitleColor:g_theme forState:UIControlStateNormal];
            btn.frame = CGRectMake(CGRectGetWidth(view.frame)/2-AdaptedWidth(150)/2, CGRectGetMaxY(label.frame)+AdaptedHeight(90), AdaptedWidth(150), AdaptedHeight(35));
            btn.layer.borderWidth = 1;
            [btn addTarget:self action:@selector(reloadClick) forControlEvents:UIControlEventTouchUpInside];
            btn.layer.borderColor = g_theme.CGColor;
            btn.layer.cornerRadius=CGRectGetHeight(btn.frame)/2;
            [view addSubview:btn];
        }
    }
    return _reloadView;
}

/** 加载某个地址 */
- (void)loadURL:(NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    [self loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)loadURL_hasPostTest:(NSString *)urlString {
    _webUrl = urlString;
    //    if (!self.isPost) {
    //        [self loadTestPost];
    //    }else{
    NSURL *url = [NSURL URLWithString:urlString];
    [self loadRequest:[NSURLRequest requestWithURL:url]];
    //  }
}

/** 加载失败 */
- (void)loadFailure{
    [self.indicator stopAnimating];
    self.reloadView.hidden = NO;
}

/** 加载中 */
- (void)loading{
    self.reloadView.hidden = YES;
    [self.indicator startAnimating];
    self.close.hidden = !self.closeShow;
}

/** 加载完成 */
- (void)loadFinished{
    self.isPost = YES;
    [self.indicator stopAnimating];
    self.reloadView.hidden = YES;
    self.close.hidden = YES;
}

- (void)createUI {
    self.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    [self addSubview:self.reloadView];
}
-(void)rightBarButtonClick{
    self.closeClickBlock();
}
- (void)reloadClick{
    if (_webUrl) {
        NSURL *url = [NSURL URLWithString:_webUrl];
        [self loadRequest:[NSURLRequest requestWithURL:url]];
    }
}



#pragma mark - 设置
/** 固定 */
- (void)fixed{
    self.scrollView.scrollEnabled = NO;
    self.scrollView.bounces = NO;
    
}



@end
