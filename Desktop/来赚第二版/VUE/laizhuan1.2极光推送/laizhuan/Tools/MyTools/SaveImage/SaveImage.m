//
//  SaveImage.m
//  laizhuan
//
//  Created by thor on 2018/5/29.
//  Copyright © 2018年 houbu. All rights reserved.
//

#import "SaveImage.h"
#import <Photos/Photos.h>
#import "Const.h"
#import "PhoneInfo.h"
#import "Global_ui.h"
#import "WKWebView+ZFJViewCapture.h"

@interface SaveImage()

@property (nonatomic, copy) SaveImageBlock saveQR;

@property (nonatomic, strong) UIImageView *img;

@end


@implementation SaveImage

#pragma mark - 申请相册访问权限
+ (void)saveImageAuth:(SaveImageAuth)auth{
    // 是否同意向本地存图片
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined:
        { // 未授权,弹出授权框
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                // 用户选择完毕就会调用—选择允许,直接保存
                if (status == PHAuthorizationStatusAuthorized) {
                    auth(YES);
                }
            }];
            break;
        }
        case PHAuthorizationStatusAuthorized:
        { // 授权,就直接保存
            auth(YES);
            break;
        }
        default:
        {// 拒绝   告知用户去哪打开授权
            auth(NO);
            break;
        }
    }
}


#pragma mark - 生成二维码-保存到本地
- (UIImage *)excludeFuzzyImageFromCIImage: (CIImage *)image size: (CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    //通过比例计算，让最终的图像大小合理（正方形是我们想要的）
    CGFloat scale = MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext * context = [CIContext contextWithOptions: nil];
    CGImageRef bitmapImage = [context createCGImage: image fromRect: extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    //切记ARC模式下是不会对CoreFoundation框架的对象进行自动释放的，所以要我们手动释放
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage: scaledImage];
}
- (void)loadImageFinished:(UIImage *)image{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        self.saveQR(1,@"");
    }else{
        self.saveQR(0,error.localizedDescription);
    }
}
-(void)saveUrlQRImage:(NSString *)url block:(SaveImageBlock)block{
    self.saveQR = block;
    
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    NSString *string = url;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 3. 生成二维码
    
    CIImage *image =[filter outputImage];
    
    UIImage *imagex=[self excludeFuzzyImageFromCIImage:image size:200];
    
    // 4. 显示二维码
    
    self.img.image = imagex;
    
    UIImageWriteToSavedPhotosAlbum(imagex, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

#pragma mark - 屏幕截屏-全屏
-(void)saveFullScreenWithView:(WKWebView *)webView block:(SaveImageBlock)block{
     self.saveQR = block;
    UIImage *image = [self getImage:webView];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
//   [webView ZFJContentCaptureCompletionHandler:^(UIImage *capturedImage) {
//        UIImageWriteToSavedPhotosAlbum(capturedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
//    }];;
}

- (UIImage *)getImage:(WKWebView *)webView{
    
    UIGraphicsBeginImageContextWithOptions(webView.bounds.size, true, 0);
    for (UIView *subView in webView.subviews) {
        [subView drawViewHierarchyInRect:subView.bounds afterScreenUpdates:true];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}




-(UIImage *)convertWholePageToImage:(WKWebView *)wkweb{
    
    CGFloat boundsWidth = wkweb.bounds.size.width;
    
    CGFloat boundsHeight = wkweb.bounds.size.height;
    
    UIScrollView *scrollView = wkweb.scrollView;
    
    CGPoint oldOffset = scrollView.contentOffset;
    
    [scrollView setContentOffset:CGPointZero animated:NO];
    
    CGFloat contentHeight = scrollView.contentSize.height;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    
    
    NSMutableArray *images = [NSMutableArray array];
    
    while (contentHeight > 0) {
        
        UIGraphicsBeginImageContextWithOptions(wkweb.bounds.size, NO, scale);
        
        [wkweb.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        [images addObject:image];
        
        CGFloat offsetY = scrollView.contentOffset.y;
        
        [scrollView setContentOffset:CGPointMake(0, offsetY + boundsHeight) animated:NO];
        
        contentHeight -= boundsHeight;
        
    }//针对webView一屏幕一屏幕的截图拼接
    
    [scrollView setContentOffset:oldOffset animated:NO];
    
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, scale);
    
    for (NSInteger index = 0; index < images.count; index++) {
        
        UIImage *image = images[index];
        
        [image drawInRect:CGRectMake(0, boundsHeight * index, boundsWidth, boundsHeight)];
        
    }
    
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return fullImage;
    
}



@end
