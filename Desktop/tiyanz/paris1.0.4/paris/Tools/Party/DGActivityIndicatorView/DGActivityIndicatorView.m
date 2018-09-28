//
//  DGActivityIndicatorView.m
//  DGActivityIndicatorExample
//
//  Created by TonyAng on 16/4/1.
//  Copyright © 2016年 TonyAng. All rights reserved.
//

#import "DGActivityIndicatorView.h"
#import "DGActivityIndicatorAnimationProtocol.h"
#import "DGActivityIndicatorBallClipRotateMultipleAnimation.h"


static const CGFloat kDGActivityIndicatorDefaultSize = 50.0f;

@implementation DGActivityIndicatorView

#pragma mark -
#pragma mark Constructors

- (id)initWithType:(DGActivityIndicatorAnimationType)type {
    return [self initWithType:type tintColor:[UIColor whiteColor] size:kDGActivityIndicatorDefaultSize];
}

- (id)initWithType:(DGActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor {
    return [self initWithType:type tintColor:tintColor size:kDGActivityIndicatorDefaultSize];
}

- (id)initWithType:(DGActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor size:(CGFloat)size {
    self = [super init];
    if (self) {
        _type = type;
        _size = size;
        _tintColor = tintColor;
        self.userInteractionEnabled = NO;
        self.hidden = YES;
    }
    return self;
}

#pragma mark -
#pragma mark Methods

- (void)setupAnimation {
    self.layer.sublayers = nil;
    
    id<DGActivityIndicatorAnimationProtocol> animation = [DGActivityIndicatorView activityIndicatorAnimationForAnimationType:_type];
    
    if ([animation respondsToSelector:@selector(setupAnimationInLayer:withSize:tintColor:)]) {
        [animation setupAnimationInLayer:self.layer withSize:CGSizeMake(_size, _size) tintColor:_tintColor];
        self.layer.speed = 0.0f;
    }
}

- (void)startAnimating {
    if (!self.layer.sublayers) {
        [self setupAnimation];
    }
    self.hidden = NO;
    self.layer.speed = 1.0f;
    _animating = YES;
}

- (void)stopAnimating {
    self.layer.speed = 0.0f;
    _animating = NO;
    self.hidden = YES;
}

#pragma mark -
#pragma mark Setters

- (void)setType:(DGActivityIndicatorAnimationType)type {
    if (_type != type) {
        _type = type;
        
        [self setupAnimation];
    }
}

- (void)setSize:(CGFloat)size {
    if (_size != size) {
        _size = size;
        
        [self setupAnimation];
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    if (![_tintColor isEqual:tintColor]) {
        _tintColor = tintColor;
        
        for (CALayer *sublayer in self.layer.sublayers) {
            sublayer.backgroundColor = tintColor.CGColor;
        }
    }
}

#pragma mark -
#pragma mark Getters

+ (id<DGActivityIndicatorAnimationProtocol>)activityIndicatorAnimationForAnimationType:(DGActivityIndicatorAnimationType)type {
    return [[DGActivityIndicatorBallClipRotateMultipleAnimation alloc]init];
}

@end
