//
//  MisicPlayer.m
//  BgModel
//
//  Created by thor on 2018/6/21.
//  Copyright © 2018年 lety. All rights reserved.
//

#import "MisicPlayer.h"
#import "AVPlayer_Plus.h"

@interface MisicPlayer()<AVPlayer_PlusDelegate>

@property (strong, nonatomic) AVPlayer_Plus *player;//播放器

@end


@implementation MisicPlayer

+ (instancetype)sharedMisicPlayer{
    static dispatch_once_t onceToken;
    static MisicPlayer *handle;
    
    dispatch_once(&onceToken, ^{
        handle = [[MisicPlayer alloc] init];
    });
    return handle;
}

- (void)setup{
    self.player = [[AVPlayer_Plus alloc] init];
    self.player.currentMode = AVPlayerPlayModeSequenceList;//顺序播放
    self.player.delegate = self;
    //[NSURL URLWithString:@"http://audio.xmcdn.com/group29/M04/BE/DA/wKgJWVle4BjzvgpgAS4Y4A7PBjQ631.m4a"],
    self.player.playListArray = @[
                                  [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"a" ofType:@"m4a"]]
                                  ];//设置播放列表
    //接收后台音频播放器的远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(misicInterruption:) name:AVAudioSessionInterruptionNotification object:nil];
}
- (void)misicInterruption:(NSNotification *)notification{
    
    AVAudioSessionInterruptionType type = [notification.userInfo[AVAudioSessionInterruptionTypeKey] intValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        [self.player pause];
    } else {
        [self.player play];
    }
}

#pragma mark - AVPlayer_PlusDelegate
- (void)player:(AVPlayer_Plus *)player playerSateDidChanged:(AVPlayerStatus)playerStatus{
    //TODO: 获取当前播放器状态
    if(playerStatus == AVPlayerStatusReadyToPlay){
        [self.player play];
    }
}

- (void)player:(AVPlayer_Plus *)player playingSateDidChanged:(BOOL)isPlaying{
    //TODO: 监听当前播放状态改变
  //  NSLog(@"isPlaying= %d",isPlaying);
}

- (void)player:(AVPlayer_Plus *)player playerIsPlaying:(NSTimeInterval)currentTime restTime:(NSTimeInterval)restTime progress:(CGFloat)progress{
    //TODO: 获取当前播放进度
  //  NSLog(@"当前播放时间:%.0f\n剩余播放时间:%.0f\n当前播放进度:%.2f\n总时长为:%.0f", currentTime, restTime, progress, player.duration);
}


- (void)play{
    if (!self.player) {
        [self setup];
    }else{
        [self.player play];
    }
}
-(void)pause{
    [self.player pause];
}



@end











