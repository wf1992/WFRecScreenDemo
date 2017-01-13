//
//  WFCapture.h
//  ScreenCaptureViewTest
//
//  Created by WF li on 16-8-24.
//  Copyright 2016年 WF. All rights reserved.
//
//视频录制部分
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "WFCaptureUtilities.h"
@protocol WFCaptureDelegate;
@interface WFCapture : NSObject{
    
    AVAssetWriter *videoWriter;
	AVAssetWriterInput *videoWriterInput;
	AVAssetWriterInputPixelBufferAdaptor *avAdaptor;
    //recording state
//	BOOL           _recording;     //正在录制中
    BOOL           _writing;       //正在将帧写入文件
	NSDate         *startedAt;     //录制的开始时间
    CGContextRef   context;        //绘制layer的context
    NSTimer        *timer;         //按帧率写屏的定时器
    
    //Capture Layer
    CALayer *_captureLayer;              //要绘制的目标layer
    NSUInteger  _frameRate;              //帧速
    id<WFCaptureDelegate> _delegate;     //代理
    
    }
@property(assign) NSUInteger frameRate;
@property(assign) float spaceDate;//秒
@property(nonatomic, strong) CALayer *captureLayer;
@property(nonatomic, strong) id<WFCaptureDelegate> delegate;
@property (nonatomic, readonly) BOOL recording;
@property (assign, nonatomic) BOOL isPause;
@property(nonatomic, copy) NSString *opPath;


//创建实例
+ (WFCapture *)sharedRecorder;
//开始录制
- (bool)startRecording1;
//结束录制
- (void)stopRecording;
//暂停录制
-(void)pauseRecording;
//重新开始录制
-(void)resumeRecording;

@end


@protocol WFCaptureDelegate <NSObject>

- (void)recordingFinished:(NSString*)outputPath;
- (void)recordingFaild:(NSError *)error;

@end
