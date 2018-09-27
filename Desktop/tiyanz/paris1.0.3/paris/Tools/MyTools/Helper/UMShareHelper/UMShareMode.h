//
//  UMShareMode.h
//  laigou
//
//  Created by thor on 2016/12/9.
//  Copyright © 2016年 thor. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 NSString *contentTitle = self.shareDic[@"title"];
 NSString *imageURL = self.shareDic[@"image-url"];
 NSString *quote = self.shareDic[@"quote"];
 NSString *contentURL = self.shareDic[@"content-url"];
 */




@interface UMShareMode : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *descr;
@property (nonatomic, strong) NSString *thumbURL;
@property (nonatomic, strong) NSString *webpageUrl;
@property (nonatomic, strong) NSString *invite_url;
@property (nonatomic, assign) BOOL isInvite;

@property (nonatomic, strong) NSString *num_iid;


@end
