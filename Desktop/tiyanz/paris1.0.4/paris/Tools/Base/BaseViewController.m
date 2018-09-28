//
//  BaseViewController.m
//  xiongmaodai
//
//  Created by thor on 2017/8/1.
//  Copyright © 2017年 gone. All rights reserved.
//

#import "BaseViewController.h"
#import "UINavigationBar+handle.h"

@interface BaseViewController ()

@property (nonatomic, assign) BOOL isSetupLeftBarButton;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBackgroundGray;
    [self initNav];
    
}

- (void)initNav{
    
    // 标题
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:RGBCOLOR(50, 51, 53)}];
    
    // 返回键
    if (self.navigationController.viewControllers.count > 1) {
        self.isSetupLeftBarButton = YES;
        [self creatLeftBarButton];
    }
    // 导航栏背景
    [self.navigationController.navigationBar navBarBackGroundColor:RGBCOLOR(255, 216, 1) image:nil];//颜色
    //   [self.navigationController.navigationBar navBarMyLayerHeight:64];//背景高度
    //    [self.navigationController.navigationBar navBarAlpha:0];//透明度
    [self.navigationController.navigationBar navBarBottomLineHidden:YES];//隐藏底线
}

- (void)setupLeftBarButton{
    if (!self.isSetupLeftBarButton) {
        [self creatLeftBarButton];
    }
}

- (void)setupRightBarButton:(NSString *)title{
    [self creatRightBtn: title];
}


- (void)creatLeftBarButton{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    UIImage * bImage = [UIImage imageNamed:@"back"];
    [btn addTarget: self action: @selector(leftBarButtonClick)forControlEvents: UIControlEventTouchUpInside];
    [btn setImage: bImage forState: UIControlStateNormal];
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -28, 0, 0);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)creatRightBtn:(NSString *)title{
    UIButton * btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(rightBarButtonClick)forControlEvents: UIControlEventTouchUpInside];
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    if (phoneVersion.floatValue>=11) {
       // btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
      //  btn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    }
    UIBarButtonItem * lb = [[UIBarButtonItem alloc] initWithCustomView: btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = - 15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,lb];
}

- (void)setupRightBarButtonImage:(NSString *)imageString{
    UIButton * btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(rightBarButtonClick)forControlEvents: UIControlEventTouchUpInside];
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    if (phoneVersion.floatValue>=11) {
        // btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //  btn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    }
    UIBarButtonItem * lb = [[UIBarButtonItem alloc] initWithCustomView: btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -55;
    self.navigationItem.rightBarButtonItems = @[lb,negativeSpacer];
}

- (void)leftBarButtonClick{
    if (self.navigationController.viewControllers.count==1) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonClick{
   
}




@end

























