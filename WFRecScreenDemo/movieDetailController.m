//
//  movieDetailController.m
//  YJGuidanceLearning
//
//  Created by gongweimeng on 16/8/1.
//  Copyright © 2016年 YJ. All rights reserved.
//

#import "movieDetailController.h"

@interface movieDetailController ()
{
    BOOL isFullScreen;
    int timeValue;
    NSString *beginTime;
    NSTimer *timer;
    UIView * topNaviView;//导航栏的背景图

}
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@end

@implementation movieDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    timeValue=0;
    beginTime=[[NSString alloc]init];
    [self initNav];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackStateDidChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}
- (void)moviePlaybackStateDidChange:(NSNotification *)note {
    switch (self.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            if (timer) {
                [timer invalidate];
                timer=nil;
            }
            timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(addTimeValue) userInfo:nil repeats:YES];
            break;
        case MPMoviePlaybackStateSeekingBackward:
        case MPMoviePlaybackStateSeekingForward:
            break;
        case MPMoviePlaybackStateInterrupted:
            break;
        case MPMoviePlaybackStatePaused:
            if (timer) {
                [timer invalidate];
                timer=nil;
            }
            break;
        case MPMoviePlaybackStateStopped:
            if (timer) {
                [timer invalidate];
                timer=nil;
            }
            break;
        default:
            break;
    }
}
- (void)movieFinished:(NSNotification *)note {
    if (timer) {
        [timer invalidate];
        timer=nil;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.moviePlayer play];
}
- (MPMoviePlayerController *)moviePlayer
{
    if (!_moviePlayer) {
        // 负责控制媒体播放的控制器
        _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:self.videoPath]];
        _moviePlayer.view.frame=CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height);
        _moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_moviePlayer.view];
    }
    return _moviePlayer;
}

-(void)setUpNavi
{
    topNaviView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, viewWidth, 50)];
    topNaviView.backgroundColor=MainColor;
    topNaviView.userInteractionEnabled=YES;
    [self.view addSubview:topNaviView];
    
    UIButton *myleftBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    [myleftBtn addTarget:self action:@selector(myleftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [myleftBtn setBackgroundColor:[UIColor clearColor]];
    [myleftBtn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    myleftBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [topNaviView addSubview:myleftBtn];
    UIButton *myleftTitleBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(myleftBtn.frame), 10, 50, 30)];
    [myleftTitleBtn addTarget:self action:@selector(myleftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [myleftTitleBtn setBackgroundColor:[UIColor clearColor]];
    [myleftTitleBtn.titleLabel setFont:[UIFont systemFontOfSize:21]];
    [myleftTitleBtn setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"local_back", nil)] forState:UIControlStateNormal];
    myleftTitleBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    [topNaviView addSubview:myleftTitleBtn];
    
}


-(void)initNav
{
    
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    //返回按钮
    [self initLeftBtn];
}
-(void)initLeftBtn
{
    [self.navigationItem setHidesBackButton:YES];
    UIButton *myleftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [myleftBtn addTarget:self action:@selector(myleftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [myleftBtn setBackgroundColor:[UIColor clearColor]];
    [myleftBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
//    [myleftBtn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    [myleftBtn setTitle:[NSString stringWithFormat:@" %@",@"返回"] forState:UIControlStateNormal];
//    myleftBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    UIBarButtonItem *leftBarButon=[[UIBarButtonItem alloc]initWithCustomView:myleftBtn];
    self.navigationItem.leftBarButtonItem=leftBarButon;
}
-(void)addTimeValue
{
    timeValue=timeValue+1;
//    NSLog(@"timeValue===== %d",timeValue);
}
-(void)myleftBtn:(UIButton *)sender
{
    [self.moviePlayer stop];
    if (timer) {
        [timer invalidate];
        timer=nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
