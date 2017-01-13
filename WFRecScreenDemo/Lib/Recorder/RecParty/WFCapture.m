//
//  THCapture.m
//  ScreenCaptureViewTest
//
//  Created by wayne li on 11-8-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WFCapture.h"
#import "CGContextCreator.h"
//#import "BlazeiceAppDelegate.h"

static NSString* const kFileName=@"output.mov";

@interface WFCapture()

//配置录制环境
- (BOOL)setUpWriter;
//清理录制环境
- (void)cleanupWriter;
//完成录制工作
- (void)completeRecordingSession;
//录制每一帧
- (void)drawFrame;
@end

@implementation WFCapture
@synthesize frameRate=_frameRate;
@synthesize captureLayer=_captureLayer;
@synthesize delegate=_delegate;

static WFCapture *_screenRecorder;


+ (WFCapture *)sharedRecorder
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _screenRecorder = [[self alloc] init];
        _screenRecorder.frameRate = 10;//默认帧率为10
    });
    
    return _screenRecorder;
}
- (id)init
{
    self = [super init];
    if (self) {
        _recording = NO;
        _isPause = NO;
        
        }
    
    return self;
}

- (void)dealloc {
	[self cleanupWriter];
}

#pragma mark -
#pragma mark CustomMethod

- (bool)startRecording1
{
    bool result = NO;
    if (! _recording )
    {
        result = [self setUpWriter];
        if (result)
        {
            startedAt = [NSDate date];
            _spaceDate=0;
            _recording = true;
            _writing = false;
            //绘屏的定时器
//            NSDate *nowDate = [NSDate date];
//            timer = [[NSTimer alloc] initWithFireDate:nowDate interval:1.0/_frameRate target:self selector:@selector(drawFrame) userInfo:nil repeats:YES];
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0/self.frameRate target:self selector:@selector(drawFrame) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        }
    }
	return result;
}


-(void)pauseRecording
{
    @synchronized(self) {
        if (_recording) {
            NSLog(@"暂停~");
            _isPause = YES;
            _recording = NO;
        }
    }
}


-(void)resumeRecording
{
    @synchronized(self) {
        if (_isPause) {
            NSLog(@"继续~");
            _recording = YES;
            _isPause = NO;
        }
    }
}


- (void)stopRecording
{
//    if (_recording) {
        NSLog(@"结束~");
        _isPause = NO;
         _recording = false;
        [timer invalidate];
        timer = nil;
        [self completeRecordingSession];
        [self cleanupWriter];
//    }
}

//buffer写入成视频的方法
-(void) writeVideoFrameAtTime:(CMTime)time addImage:(CGImageRef )newImage
{
    //视频输入是否准备接受更多的媒体数据
    if (![videoWriterInput isReadyForMoreMediaData]) {
        NSLog(@"Not ready for video data");
    } else {
        
        @synchronized (self) {//创建一个互斥锁，保证此时没有其它线程对self对象进行修改

            CVPixelBufferRef pixelBuffer = NULL;
            CGImageRef cgImage = CGImageCreateCopy(newImage);
            CFDataRef image = CGDataProviderCopyData(CGImageGetDataProvider(cgImage));
            
            int status = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, avAdaptor.pixelBufferPool, &pixelBuffer);
            if(status != 0){
                //could not get a buffer from the pool
                NSLog(@"Error creating pixel buffer:  status=%d", status);
            }
            // set image data into pixel buffer
            CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
            uint8_t* destPixels = CVPixelBufferGetBaseAddress(pixelBuffer);
            CFDataGetBytes(image, CFRangeMake(0, CFDataGetLength(image)), destPixels);  //XXX:  will work if the pixel buffer is contiguous and has the same bytesPerRow as the input data
            
            if(status == 0) {
                
                BOOL success = [avAdaptor appendPixelBuffer:pixelBuffer withPresentationTime:time];
                if (!success)
                    NSLog(@"Warning:  Unable to write buffer to video");
            }
            
            //clean up
            CVPixelBufferUnlockBaseAddress( pixelBuffer, 0 );
            CVPixelBufferRelease( pixelBuffer );
            CFRelease(image);
            CGImageRelease(cgImage);
        }
        
    }
}


- (void)drawFrame
{
    if (_isPause) {
        //计算暂停的时间 并且在暂停的时候停止视频的写入
     _spaceDate=_spaceDate+1.0/self.frameRate;
     return;
     }

    if (!_writing) {
        [self performSelectorInBackground:@selector(getFrame) withObject:nil];
    }
}

- (void)getFrame
{
    if (!_writing) {
        _writing = true;
        size_t width  = CGBitmapContextGetWidth(context);
        size_t height = CGBitmapContextGetHeight(context);
        @try {
            CGContextClearRect(context, CGRectMake(0, 0,width , height));
            
//            [self.captureLayer renderInContext:context];
//            self.captureLayer.contents=nil;

            [[[UIApplication sharedApplication].delegate window].layer renderInContext:context];
            [[UIApplication sharedApplication].delegate window].layer.contents = nil;
             CGImageRef cgImage = CGBitmapContextCreateImage(context);
            
            if (_recording) {
                float millisElapsed = [[NSDate date] timeIntervalSinceDate:startedAt] * 1000.0-_spaceDate*1000.0;
                //NSLog(@"millisElapsed = %f",millisElapsed);
                [self writeVideoFrameAtTime:CMTimeMake((int)millisElapsed, 1000) addImage:cgImage];
            }
            CGImageRelease(cgImage);
        }
        @catch (NSException *exception) {
            
        }
        _writing = false;
    }
}

//视频的存放地址（最好是放在caches里面，我这是项目需要才写的）
- (NSString*)tempFilePath {
    
    NSFileManager * fileManager =[NSFileManager defaultManager];
    NSString *finalPath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/myVideo"];
    if (![fileManager fileExistsAtPath:finalPath]) {
        BOOL res=[fileManager createDirectoryAtPath:finalPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {
        }else
        {
        }
    }
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    NSString *outputPath = [finalPath stringByAppendingPathComponent:
                            [NSString stringWithFormat:@"%lld.mp4",date]];
    NSLog(@"outputPath123   %@",outputPath);
    [self removeTempFilePath:outputPath];
    return outputPath;
    
}

- (void)removeTempFilePath:(NSString*)filePath
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError* error;
        if ([fileManager removeItemAtPath:filePath error:&error] == NO) {
            NSLog(@"Could not delete old recording:%@", [error localizedDescription]);
        }
    }
}

//初始化视频写入的类
-(BOOL) setUpWriter {
    [self is64bit];

    CGSize tmpsize = [UIScreen mainScreen].bounds.size;
    float scaleFactor = [[UIScreen mainScreen] scale];
    CGSize size = CGSizeMake(tmpsize.width*scaleFactor, tmpsize.height*scaleFactor);
    NSError *error = nil;
    NSString *filePath=[self tempFilePath];
    _opPath = filePath;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        
        if ([fileManager removeItemAtPath:filePath error:&error] == NO) {
            NSLog(@"Could not delete old recording file at path:  %@", filePath);
            return NO;
        }
    }
    
    //configure videoWriter
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    videoWriter = [[AVAssetWriter alloc] initWithURL:fileUrl fileType:AVFileTypeQuickTimeMovie error:&error];
    NSParameterAssert(videoWriter);
    
    //Configure videoWriterInput
    NSDictionary* videoCompressionProps = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithDouble:size.width*size.height], AVVideoAverageBitRateKey,//视频尺寸*比率，10.1相当于AVCaptureSessionPresetHigh，数值越大，显示越精细
                                           nil ];
    
    
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:size.height], AVVideoHeightKey,
                                   videoCompressionProps, AVVideoCompressionPropertiesKey,
                                   nil];
    videoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    
    NSParameterAssert(videoWriterInput);
    videoWriterInput.expectsMediaDataInRealTime = YES;
    
    
    
    NSMutableDictionary* bufferAttributes = [[NSMutableDictionary alloc] init];
    
    [bufferAttributes setObject:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA] forKey:(NSString*)kCVPixelBufferPixelFormatTypeKey];//之前配置的下边注释掉的context使用的是kCVPixelFormatType_32ARGB，用起来颜色没有问题。但是用UIGraphicsBeginImageContextWithOptions([[UIApplication sharedApplication].delegate window].bounds.size, YES, 0);配置的context使用kCVPixelFormatType_32ARGB的话颜色会变成粉色，替换成kCVPixelFormatType_32BGRA之后，颜色正常。。。
    
    [bufferAttributes setObject:[NSNumber numberWithUnsignedInt:size.width] forKey:(NSString*)kCVPixelBufferWidthKey];//这个位置包括下面的两个，必须写成(int)size.width/16*16,因为这个的大小必须是16的倍数，否则图像会发生拉扯、挤压、旋转。。。。不知道为啥
    [bufferAttributes setObject:[NSNumber numberWithUnsignedInt:size.height ] forKey:(NSString*)kCVPixelBufferHeightKey];
     [bufferAttributes setObject:@YES forKey:(NSString*)kCVPixelBufferCGBitmapContextCompatibilityKey];
    
    avAdaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoWriterInput sourcePixelBufferAttributes:bufferAttributes];
    
    //add input
    [videoWriter addInput:videoWriterInput];
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:CMTimeMake(0, 1000)];

    
    //create context
    if (context== NULL)
    {
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//        context = CGBitmapContextCreate (NULL,
//                                         size.width,
//                                         size.height,
//                                         8,//bits per component
//                                         size.width * 4,
//                                         colorSpace,
//                                         kCGImageAlphaNoneSkipFirst);
//        CGColorSpaceRelease(colorSpace);
//        CGContextSetAllowsAntialiasing(context,NO);
//        CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0,-1, 0, size.height);
//        CGContextConcatCTM(context, flipVertical);
        
        UIGraphicsBeginImageContextWithOptions([[UIApplication sharedApplication].delegate window].bounds.size, YES, 0);
        context = UIGraphicsGetCurrentContext();
        
    }
    if (context== NULL)
    {
		fprintf (stderr, "Context not created!");
        return NO;
	}
	
	return YES;
}

//结束清除
- (void) cleanupWriter {
   
	avAdaptor = nil;
	
	videoWriterInput = nil;
	
	videoWriter = nil;
	
	startedAt = nil;
    

    //CGContextRelease(context);
    //context=NULL;
}

//视频录制完毕调用
- (void) completeRecordingSession {
     
	
	[videoWriterInput markAsFinished];
	
	// Wait for the video
//	int status = videoWriter.status;
//	while (status == AVAssetWriterStatusUnknown)
//    {
//		NSLog(@"Waiting...");
//		[NSThread sleepForTimeInterval:0.5f];
//		status = videoWriter.status;
//	}
        BOOL success = [videoWriter finishWriting];
        if (!success)
        {
            NSLog(@"finishWriting returned NO");
            if ([_delegate respondsToSelector:@selector(recordingFaild:)]) {
                [_delegate recordingFaild:nil];
            }
            return ;
        }
    
    NSLog(@"Completed recording, file is stored at:  %@", _opPath);
    if ([_delegate respondsToSelector:@selector(recordingFinished:)]) {
        [_delegate recordingFinished:_opPath];
    }
    
}

- (BOOL)is64bit
{
#if defined(__LP64__) && __LP64__
    NSLog(@"设备是64位的");
    return YES;
#else
    NSLog(@"设备是32位的");
    return NO;
#endif
}


@end
