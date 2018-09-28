//
//  SaveQRcode.m
//  paris
//
//  Created by thor on 2018/9/7.
//  Copyright © 2018年 paris. All rights reserved.
//

#import "SaveQRcode.h"
#import "Const.h"
#import "Global_ui.h"
#import "SaveImage.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SaveQRcode()

@property (nonatomic, assign)CGFloat qrHeight;

@end

@implementation SaveQRcode

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUIWithFrame:frame];
    }
    return self;
}

- (void)initUIWithFrame:(CGRect)frame{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(frame.size.width/2-AdaptedWidth(100)/2, AdaptedHeight(10), AdaptedWidth(100), AdaptedWidth(100));
    imageView.image = [Const SG_generateWithColorQRCodeData:API_app_download backgroundColor:[CIColor colorWithRed:0 green:0 blue:0] mainColor:[CIColor colorWithRed:255 green:255 blue:255]];
    [self addSubview:imageView];
    {
        UIImageView *logo = [[UIImageView alloc] init];
        logo.frame = CGRectMake(CGRectGetWidth(imageView.frame)/2-AdaptedWidth(20)/2,CGRectGetHeight(imageView.frame)/2-AdaptedHeight(20)/2, AdaptedWidth(20), AdaptedWidth(20));
        logo.image = [UIImage imageNamed:@"logo"];
        [imageView addSubview:logo];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0,CGRectGetMaxY(imageView.frame)+AdaptedWidth(10), frame.size.width, AdaptedHeight(70));
    label.lineBreakMode= NSLineBreakByCharWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.attributedText = [Const attributedString:@"寻回二维码\n" dic1:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor blackColor]} str2:@"*请保存二维码到相册,\n在app不小心删除的意外情况,\n可以通过相册中的二维码来找回app" dic2:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor grayColor]}];
    [self addSubview:label];
    self.qrHeight = CGRectGetMaxY(label.frame)+AdaptedHeight(10);
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:g_theme forState:UIControlStateNormal];
    btn.frame = CGRectMake(frame.size.width/2-AdaptedWidth(150)/2, CGRectGetMaxY(label.frame)+AdaptedHeight(100), AdaptedWidth(150), AdaptedHeight(35));
    btn.layer.borderWidth = 1;
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.borderColor = g_theme.CGColor;
    btn.layer.cornerRadius=CGRectGetHeight(btn.frame)/2;
    [self addSubview:btn];
    
}

- (void)btnAction{
    
    [SaveImage saveImageAuth:^(bool agree) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SaveImage *saveImage = [[SaveImage alloc] init];
            UIImage *image = [self getImage];
            if (agree) {
                [saveImage saveImage:image block:^(int type, NSString *msg) {
                    if (type == 0) {
                        [Const alertWith:msg];
                    }else if(type == 1){
                        // 保存成功
                    }
                    self.agree(YES);
                }];
            }else{
                [Const alertWith:@"请至手机‘设置’中，允许app访问相册"];
            }
        });
    }];
}

- (UIImage *)getImage{
    
    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *imge = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRef imageRefRect = CGImageCreateWithImageInRect(imge.CGImage,CGRectMake(0, 0, self.frame.size.width, self.qrHeight));
    UIImage * cutImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    
    
//    UIGraphicsBeginImageContextWithOptions(webView.bounds.size, true, 0);
//    for (UIView *subView in webView.subviews) {
//        [subView drawViewHierarchyInRect:subView.bounds afterScreenUpdates:true];
//    }
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    return cutImage;
}


@end
