//
//  BaseViewController.h
//  xiongmaodai
//
//  Created by thor on 2017/8/1.
//  Copyright © 2017年 gone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)setupLeftBarButton;
- (void)leftBarButtonClick;

- (void)setupRightBarButton:(NSString *)title;
- (void)rightBarButtonClick;

- (void)setupRightBarButtonImage:(NSString *)imageString;

@end
