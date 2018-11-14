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

@property (nonatomic, strong)UIImageView *reloadImageView;

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
        _indicator = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeCookieTerminator tintColor:[UIColor grayColor]];
        CGFloat width = Screen_Width / 5.0f;
        CGFloat height = Screen_Height / 7.0f;
        
        _indicator.frame = CGRectMake(Screen_Width/2-width/2, Screen_Height/2-height/2, width, height);
        [self addSubview:_indicator];
    }
    return _indicator;
}

- (UIImageView*)reloadImageView {
    if (!_reloadImageView) {
        _reloadImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty_signal"]];
        _reloadImageView.userInteractionEnabled = YES;
        _reloadImageView.frame = CGRectMake(0, 0, AdaptedWidth(320), AdaptedWidth(320));
        _reloadImageView.center = self.center;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadClick)];
        [_reloadImageView addGestureRecognizer:tap];
        [self addSubview:_reloadImageView];
    }
    return _reloadImageView;
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
    self.reloadImageView.hidden = NO;
}

/** 加载中 */
- (void)loading{
    self.reloadImageView.hidden = YES;
    [self.indicator startAnimating];
    self.close.hidden = !self.closeShow;
}

/** 加载完成 */
- (void)loadFinished{
    self.isPost = YES;
    [self.indicator stopAnimating];
    self.reloadImageView.hidden = YES;
    self.close.hidden = YES;
}

//-(void)loadTestPost{
//    // 判断403、404
//    NSURL *url = [NSURL URLWithString:self.urlString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSHTTPURLResponse *response = nil;
//    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//    if (response.statusCode == 404 || response.statusCode == 403) {
//        [self loadFailure];
//    } else {
//        [self loadRequest:[NSURLRequest requestWithURL:url]];
//    }
//}

- (void)createUI {
    self.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    [self addSubview:self.reloadImageView];
    
   
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






























#pragma mark -  加载本地Bundle

- (void)loadBundleHtmlName:(NSString *)htmlName{
    //调用逻辑
    NSString *path = [[NSBundle mainBundle] pathForResource:htmlName ofType:@"html"];
    if(path){
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            // iOS9. One year later things are OK.
            NSURL *fileURL = [NSURL fileURLWithPath:path];
            [self loadFileURL:fileURL allowingReadAccessToURL:fileURL];
        } else {
            // iOS8. Things can be workaround-ed
            //   Brave people can do just this
            //   fileURL = try! pathForBuggyWKWebView8(fileURL)
            //   webView.loadRequest(NSURLRequest(URL: fileURL))
            
            NSURL *fileURL = [self fileURLForBuggyWKWebView8:[NSURL fileURLWithPath:path]];
            NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
            [self loadRequest:request];
        }
    }
}

//将Bundle copy到tmp目录
- (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL {
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    // Create "/temp/www" directory
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"loading"];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    // Files in "/temp/www" load flawlesly :)
    return dstURL;
}








@end
