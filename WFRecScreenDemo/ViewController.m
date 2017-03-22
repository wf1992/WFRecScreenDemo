//
//  ViewController.m
//  WFRecScreenDemo
//
//  Created by 王飞 on 17/1/13.
//  Copyright © 2017年 WF. All rights reserved.
//

#import "ViewController.h"
#import "VideoListController.h"
#import "WFCapture.h"
#import "BlazeiceAudioRecordAndTransCoding.h"


#define VEDIOPATH @"vedioPath"

#import "BlazeiceDooleView.h"

@interface ViewController ()<WFCaptureDelegate,AVAudioRecorderDelegate,BlazeiceAudioRecordAndTransCodingDelegate,BlazeiceDooleViewDelegate>
{
    BOOL isRecing;//正在录制中
    BOOL isPauseing;//正在暂停中
    
    WFCapture *capture;
    BlazeiceAudioRecordAndTransCoding *audioRecord;
    NSString* opPath;
    NSTimer * recordTimer;
    UIButton * beginBtn;
    UIButton * pauseBtn;
    int timeCount;
    UILabel * timelable;
    UIView * backView;
    BlazeiceDooleView *doodleView;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavi];
    [self setUpFunctionBtn];
    [self setUpDrawView];

}


-(void)viewWillAppear:(BOOL)animated
{
    isRecing=NO;
    isPauseing=NO;
}


#pragma mark - 开始录制视频
-(void)beginToRecVideo
{
    if (isRecing) {
        return ;
    }
    isRecing =YES;
    [self recordMustSuccess];
    recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(recordTimerWork) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:recordTimer forMode:NSRunLoopCommonModes];
    
    beginBtn.userInteractionEnabled=NO;
    [beginBtn setBackgroundColor:[UIColor lightGrayColor]];
}


#pragma mark - 继续或者暂停录制
-(void)pauseVideo
{
    if (isRecing) {
        //暂停
        isRecing=NO;
        isPauseing=YES;
        [[WFCapture sharedRecorder] pauseRecording];
        [audioRecord pauseRecord];
        [pauseBtn setTitle:@"继续录制" forState:UIControlStateNormal];
        
        if (recordTimer) {
            [recordTimer invalidate];
            recordTimer=nil;
        }
    }else if(isPauseing)
    {
        isRecing=YES;
        isPauseing=NO;
        [[WFCapture sharedRecorder] resumeRecording];
        [audioRecord resumeRecord];
        [pauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
        
        recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(recordTimerWork) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:recordTimer forMode:NSRunLoopCommonModes];

    }
    
}

#pragma mark - 结束录制视频
-(void)stopAndSaveVideo
{
    beginBtn.userInteractionEnabled=YES;
    [beginBtn setBackgroundColor:MainColor];
    isRecing =NO;
    isPauseing=NO;
    [[WFCapture sharedRecorder]stopRecording];
    
    timeCount =0;
    timelable.text =@"00:00:00";
    if (recordTimer) {
        [recordTimer invalidate];
        recordTimer=nil;
    }

}

#pragma mark----------------开始录制
- (void)recordMustSuccess {
    capture = [WFCapture sharedRecorder];
    capture.frameRate = 35;
    capture.delegate = self;
    //    capture.captureLayer = [[UIApplication sharedApplication].delegate window].layer;
    
    if (!audioRecord) {
        audioRecord = [[BlazeiceAudioRecordAndTransCoding alloc]init];
        audioRecord.recorder.delegate=self;
        audioRecord.delegate=self;
    }
    
    [capture performSelector:@selector(startRecording1)];
    
    NSString* path=[self getPathByFileName:VEDIOPATH ofType:@"wav"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]){
        [fileManager removeItemAtPath:path error:nil];
    }
    [self performSelector:@selector(toStartAudioRecord) withObject:nil afterDelay:0.1];
    
}

- (NSString*)getPathByFileName:(NSString *)_fileName ofType:(NSString *)_type
{
    NSString* fileDirectory = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:_fileName]stringByAppendingPathExtension:_type];
    return fileDirectory;
}


#pragma mark -
#pragma mark audioRecordDelegate
/**
 *  开始录音
 */
-(void)toStartAudioRecord
{
    [audioRecord beginRecordByFileName:VEDIOPATH];
}
/**
 *  音频录制结束合成视频音频
 */
-(void)wavComplete
{
    //视频录制结束,为视频加上音乐
    if (audioRecord) {
        NSString* path=[self getPathByFileName:VEDIOPATH ofType:@"wav"];
        [WFCaptureUtilities mergeVideo:opPath andAudio:path andTarget:self andAction:@selector(mergedidFinish:WithError:)];
    }
}


#pragma mark --------------音频方法
#pragma mark CustomMethod

- (void)video: (NSString *)videoPath didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInfo{
    if (error) {
        NSLog(@"---%@",[error localizedDescription]);
    }
}

- (void)mergedidFinish:(NSString *)videoPath WithError:(NSError *)error
{
//    NSLog(@"~~~~~~~~~~~~~~~~~~~~~");
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    NSString* fileName=[NSString stringWithFormat:@"%lld.mp4",date];
    //
    NSString* path=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/myVideo/%@",fileName]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath])
    {
        NSError *err=nil;
        [[NSFileManager defaultManager] moveItemAtPath:videoPath toPath:path error:&err];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[WFCapture sharedRecorder].opPath])
    {
        NSError *err=nil;
        [[NSFileManager defaultManager]removeItemAtPath:[WFCapture sharedRecorder].opPath error:&err];
    }
    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"allVideoInfo"]) {
//        
//        NSMutableArray* allFileArr=[[NSMutableArray alloc] init];
//        [allFileArr addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"allVideoInfo"]];
//        [allFileArr insertObject:fileName atIndex:0];
//        [[NSUserDefaults standardUserDefaults] setObject:allFileArr forKey:@"allVideoInfo"];
//    }
//    else{
//        NSMutableArray* allFileArr=[[NSMutableArray alloc] init];
//        [allFileArr addObject:fileName];
//        [[NSUserDefaults standardUserDefaults] setObject:allFileArr forKey:@"allVideoInfo"];
//    }
    
    //    //音频与视频合并结束，存入相册中[THCapture sharedRecorder].opPath
    //    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
    //        NSLog(@"123~~~~");
    //        UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    //    }else
    //    {
    //        NSLog(@"错误");
    //    }
}



#pragma mark -
#pragma mark WFCaptureDelegate
- (void)recordingFinished:(NSString*)outputPath
{
    NSLog(@"outputPath %@",outputPath);
    opPath=outputPath;
    if (audioRecord) {
        [audioRecord endRecord];
    }
    //    [self mergedidFinish:outputPath WithError:nil];
}

- (void)recordingFaild:(NSError *)error
{
}

#pragma mark----------------UI布局
//画图区域
-(void)setUpDrawView
{
  
    if (doodleView) {
        [doodleView removeFromSuperview];
        doodleView =nil;
    }
    
    CGRect frame =CGRectMake(0, CGRectGetMaxY(backView.frame)+10, viewWidth,  viewHeight-CGRectGetMaxY(backView.frame)-10);
    doodleView = [[BlazeiceDooleView alloc] initWithFrame:frame];
    doodleView.delegate = self;
    doodleView.drawView.formPush = YES;
    [self.view addSubview:doodleView];
    doodleView.drawView.lineColor =[UIColor blackColor];
    doodleView.colorResult =[UIColor blackColor];;

}

//功能按钮
-(void)setUpFunctionBtn
{
    timelable = [[UILabel alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height+20+5, viewWidth, 20)];
    timelable.textAlignment =NSTextAlignmentCenter;
    timelable.text = @"00:00:00";
    timelable.textColor=[UIColor redColor];
    [self.view addSubview:timelable];
    
    //背景
    backView =[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(timelable.frame), viewWidth, 50)];
    backView.backgroundColor=[UIColor whiteColor];
    backView.userInteractionEnabled=YES;
    [self.view addSubview:backView];
    
    //开始按钮
    beginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    beginBtn.frame = CGRectMake(10, 10, (viewWidth-40)/3, 30);
    [beginBtn setTitle:@"开始" forState:UIControlStateNormal];
    [beginBtn setBackgroundColor:MainColor];
    [beginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [beginBtn addTarget:self action:@selector(beginToRecVideo) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:beginBtn];
    
    //暂停按钮
    pauseBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    pauseBtn.frame = CGRectMake(CGRectGetMaxX(beginBtn.frame)+10,10, (viewWidth-40)/3, 30);
    [pauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [pauseBtn setBackgroundColor:MainColor];
    [pauseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pauseBtn addTarget:self action:@selector(pauseVideo) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:pauseBtn];
    
    //结束按钮
    UIButton * stopAndSaveBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    stopAndSaveBtn.frame = CGRectMake(CGRectGetMaxX(pauseBtn.frame)+10, 10, (viewWidth-40)/3, 30);
    [stopAndSaveBtn setTitle:@"结束并保存" forState:UIControlStateNormal];
    [stopAndSaveBtn setBackgroundColor:MainColor];
    [stopAndSaveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [stopAndSaveBtn addTarget:self action:@selector(stopAndSaveVideo) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:stopAndSaveBtn];
    
    [self.view addSubview:backView];
    
}


-(void)setUpNavi
{
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    self.navigationController.navigationBar.barTintColor=MainColor;
    
    UIButton *leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [leftBtn addTarget:self action:@selector(clearBtnClicked)forControlEvents:UIControlEventTouchUpInside ];
    [leftBtn setTitle:@"清屏" forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    UIBarButtonItem *leftBtnBarButon=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=leftBtnBarButon;
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [rightBtn addTarget:self action:@selector(VideoBtnClicked)forControlEvents:UIControlEventTouchUpInside ];
    [rightBtn setTitle:@"视频列表" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    UIBarButtonItem *rightBarButon=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightBarButon;
    
   
    
    
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    self.navigationItem.title=@"录制视频";
    
}

//清屏
-(void)clearBtnClicked
{
    [doodleView clearBtnToRemoveAll];
}

//板擦
-(void)scrubBtnClicked
{
    [doodleView esarBtnToChangeClear];
}

//撤销
-(void)cancleBtnClicked
{
    [doodleView cancleBtnToBackForward];
}



//进入下级页面显示录制的视频
-(void)VideoBtnClicked
{
    [self stopAndSaveVideo];
    
    [self.navigationController pushViewController:[[VideoListController alloc]init] animated:YES];
}

-(void)recordTimerWork
{
    timeCount++;
    NSString * timeStr =[self timeFormatted:timeCount];
    timelable.text =timeStr;
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
