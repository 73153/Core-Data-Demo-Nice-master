//
//  ViewController.m
//  Marenba
//
//  Created by sun qichao on 14-2-8.
//  Copyright (c) 2014年 sun qichao. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface ViewController ()
@property (strong ,nonatomic) LCVoice *voice;
@property (strong ,nonatomic) AVAudioPlayer *audioPlayer;
@end

@implementation ViewController


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.voice = [[LCVoice alloc] init];
        
        //没有创建session不能播放
        NSError *setCategoryError = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&setCategoryError];
        UInt32 route = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
        
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)touchDown:(id)sender {
    DLog(@"touch down");
    [self.voice startRecordWithPath:DefaultCafPath];
    
}

- (IBAction)touchEnd:(id)sender {
    DLog(@"touch end");
    [self.voice stopRecordWithCompletionBlock:^{
        [SQCAPI saveTheVoiceToParse:DefaultCafPath withTime:self.voice.recordTime done:^(BOOL isRight) {
            
        }];
        
        if (self.voice.recordTime > 0.1f) {
            DLog(@"save succeed");
            [SVProgressHUD showSuccessWithStatus:@"发送成功，开始加入骂人的队伍中。" duration:2.0];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HidenStartViewNotification" object:nil];

            
        }
        
    }];
}

- (IBAction)touchCancel:(id)sender {
    DLog(@"touch cancel");
    [self.voice cancelled];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"取消了" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (IBAction)play:(id)sender {
    MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
    mpc.volume = 0.8;
//    NSString *path = DefaultCafPath;
    NSArray *voices = [SQCAPI getCafList:0];
    if ([voices count]>0) {
        NSData *cafData = [SQCAPI getCafDataFormParseObject:[voices objectAtIndex:1]];
        //    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:path] error:nil];
        //    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.peng.local/upload/msg/mp3/1402/13918530018543.mp3"] error:nil];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:cafData error:nil];
        
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
    }
    
}


@end
