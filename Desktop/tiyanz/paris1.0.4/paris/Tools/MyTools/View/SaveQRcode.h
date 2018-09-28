//
//  SaveQRcode.h
//  paris
//
//  Created by thor on 2018/9/7.
//  Copyright © 2018年 paris. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SaveQRcodeBlock)(int agree);

@interface SaveQRcode : UIView

@property (nonatomic, copy)SaveQRcodeBlock agree;

@end
