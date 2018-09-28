//
//  BaseWKWebController.h
//  laigou
//
//  Created by thor on 2016/12/12.
//  Copyright © 2016年 thor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "THWKWebView.h"


@interface BaseWKWebViewController : UIViewController<WKScriptMessageHandler>

@property (nonatomic, strong) THWKWebView *webView;

@property (nonatomic,strong) WKUserContentController* userContentController;

@property (nonatomic, assign) CGRect webViewFrame;

@property (nonatomic, assign) BOOL fisrtLaunch;

- (void)leftBarButtonClick;

//- (void)loadIndexHtml;


@end


@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end




