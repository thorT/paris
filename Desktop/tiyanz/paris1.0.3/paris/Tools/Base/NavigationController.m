//
//  HKNavigationController.m
//  YinKe
//
//  Created by HK on 16/12/31.
//  Copyright © 2016年 hkhust. All rights reserved.
//

#import "NavigationController.h"
#import "HomeViewController.h"

//导航栏颜色
#define NavBarColor [UIColor colorWithRed:64/255.0 green:224/255.0 blue:208/255.0 alpha:1.0]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface NavigationController ()<UINavigationControllerDelegate>

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 //   self.navigationBarHidden = YES;
    
//        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    //自定义返回按钮
   
    // 1. 设置代理
    self.delegate = self;
}

+ (void)load {
//    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedIn:self, nil ];
//    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
//    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:17.f];
//    attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    [item setTitleTextAttributes:attributes forState:UIControlStateNormal];
//    
//    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
//    [bar setBarTintColor:NavBarColor];
//    [bar setTitleTextAttributes:attributes];
}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//
//    if (self.viewControllers.count > 0) {
//        [NotificationCenter postNotificationName:kTabBarHidden object:nil];
//    }
//
//    return [super pushViewController:viewController animated:animated];
//}


#pragma mark - Private Methods
#pragma mark -
#pragma mark Whether need Navigation Bar Hidden
- (BOOL) needHiddenBarInViewController:(UIViewController *)viewController {
    
    BOOL needHideNaivgaionBar = NO;
    
    // 在这里判断, 哪个 ViewController 需要隐藏导航栏, 如果有第三方的 ViewController 也需要隐藏 NavigationBar, 我们也需要在这里设置.
    if ([viewController isKindOfClass: [HomeViewController class]]) {
        needHideNaivgaionBar = YES;
    }
    return needHideNaivgaionBar;
}


#pragma mark - UINaivgationController Delegate
#pragma mark Will Show ViewController
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 在 NavigationController 的这个代理方法中, 设置导航栏的隐藏和显示
    [self setNavigationBarHidden: [self needHiddenBarInViewController: viewController]
                        animated: animated];
    
}





@end


























