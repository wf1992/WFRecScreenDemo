//
//  writeViewPaint.m
//  personalLetter
//
//  Created by gongweimeng on 16/8/31.
//  Copyright © 2016年 GWM. All rights reserved.
//

#import "writeViewPaint.h"
#define colorCount 4
@implementation writeViewPaint
{
    KZColorPicker *picker;
    
    int forwardStatus;
    int forwardWidth;
    
    int btnSelected;
    UIView *backBtnView;
    
    
    
    CGPoint originalPoint;
    CGFloat lastScale;
//    BOOL touchCan;
    
    
    // 遮罩
    UIView      *_maskView;
    //AddView内容
    UIView      *_contentView;
    UIView      *_triangleView;
    CGRect  _triangleFrame;// 三角形位置 default : CGRectMake(width-25, 0, 12, 12)
    BOOL _isAddViewShowing;
    CGFloat     _width;
    CGPoint     _origin;

    NSMutableArray * colorArr;
    
    CGPoint firstPoint;
    CGPoint lastPoint;
    BOOL isFirst;

}
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}
-(void)setUpViews
{
    self.multipleTouchEnabled=YES;
    _isDelegateCan=YES;
    _touchCan=YES;
    _moveTouchCan=NO;
    isFirst=YES;
    lastPoint =CGPointMake(0.0, 0.0);
    lastScale=1.0;
    btnSelected=0;
    forwardStatus=0;
    forwardWidth=1.0;
    firstPoint =CGPointMake(0.0, 0.0);
    _forwardColor=[UIColor blackColor];
    self.selectedColor = [UIColor whiteColor];
    colorArr = [[NSMutableArray alloc]init];
    [colorArr addObject:[UIColor blackColor]];
    [colorArr addObject:[UIColor blueColor]];
    [colorArr addObject:[UIColor redColor]];
    [colorArr addObject:[UIColor yellowColor]];
    
    self.SegmentWidth=1.0;
    self.Segment=6;
    
    //关闭默认黑色
//    self.colorResult=[UIColor blackColor];
    
    self.backgroundColor=[UIColor clearColor];
    self.userInteractionEnabled=YES;
    
    UIImageView *backImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backImage.userInteractionEnabled=YES;
    backImage.backgroundColor=[UIColor clearColor];
    backImage.contentMode=UIViewContentModeScaleAspectFit;
    [self addSubview:backImage];
    self.backImage=backImage;
    
    
    //画图区域
    drawViewPaint *paletteView=[[drawViewPaint alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    paletteView.delegate=self;
    paletteView.backgroundColor=[UIColor clearColor];
    [self addSubview:paletteView];
    self.paletteView=paletteView;

    
    originalPoint=_backImage.center;
    [self addGestures];
    
    //底部按钮
    
    CGFloat btnW=(self.frame.size.width-20*5)/4;
    
//    //颜色和线宽
//    UIButton *colorWidthButton=[[UIButton alloc]initWithFrame:CGRectMake(20, self.frame.size.height-35, btnW, 30)];
//    [colorWidthButton addTarget:self action:@selector(colorWidthButton:) forControlEvents:UIControlEventTouchUpInside];
//    [colorWidthButton setBackgroundColor:GWMColor(255,136,45)];
//    [colorWidthButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
//    [colorWidthButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [colorWidthButton setTitle:@"画笔" forState:UIControlStateNormal];
//    CALayer *colorWidthButtonLayer=[colorWidthButton layer];
//    colorWidthButtonLayer.cornerRadius=15;
//    colorWidthButtonLayer.borderColor=[GWMColor(255,136,45)CGColor];
//    colorWidthButtonLayer.borderWidth=1.0;
//    colorWidthButtonLayer.masksToBounds=YES;
//    [self addSubview:colorWidthButton];
//    self.colorWidthButton=colorWidthButton;
//    
//    //撤销
//    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(20+(btnW+20)*3, self.frame.size.height-35, btnW, 30)];
//    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [backBtn setBackgroundColor:GWMColor(255,136,45)];
//    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
//    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [backBtn setTitle:@"撤销" forState:UIControlStateNormal];
//    CALayer *backBtnLayer=[backBtn layer];
//    backBtnLayer.cornerRadius=15;
//    backBtnLayer.borderColor=[GWMColor(255,136,45)CGColor];
//    backBtnLayer.borderWidth=1.0;
//    backBtnLayer.masksToBounds=YES;
//    [self addSubview:backBtn];
//    self.backBtn=backBtn;
//    
//    //橡皮擦
//    UIButton *forwardBtn=[[UIButton alloc]initWithFrame:CGRectMake(20+(btnW+20)*2, self.frame.size.height-35, btnW, 30)];
//    [forwardBtn addTarget:self action:@selector(forwardBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [forwardBtn setBackgroundColor:GWMColor(255,136,45)];
//    [forwardBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
//    [forwardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    NSString *str=@"橡皮擦";
//    [forwardBtn setTitle:str forState:UIControlStateNormal];
//    CALayer *forwardBtnLayer=[forwardBtn layer];
//    forwardBtnLayer.cornerRadius=15;
//    forwardBtnLayer.masksToBounds=YES;
//    [self addSubview:forwardBtn];
//    self.forwardBtn=forwardBtn;
//    
//    //重做
//    UIButton *doneBtn=[[UIButton alloc]initWithFrame:CGRectMake(20+(btnW+20)*1, self.frame.size.height-35, btnW, 30)];
//    [doneBtn setBackgroundColor:GWMColor(255,136,45)];
//    [doneBtn setTitle:@"重做" forState:UIControlStateNormal];
//    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
//    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    CALayer *doneBtnLayer=[doneBtn layer];
//    doneBtnLayer.cornerRadius=15;
//    doneBtnLayer.masksToBounds=YES;
//    [doneBtn addTarget:self action:@selector(clearBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:doneBtn];
//    self.doneBtn=doneBtn;
    
    
    
    haveWritten=NO;
}
-(void)addGestures
{
    //新建pinch手势
//    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
////    pinchGesture.delaysTouchesBegan=YES;
//    pinchGesture.cancelsTouchesInView=YES;
////    pinchGesture.delaysTouchesEnded=YES;
//    [self addGestureRecognizer:pinchGesture];
//    //新建pan手势
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
////    panGesture.delaysTouchesBegan=YES;
//    panGesture.cancelsTouchesInView=YES;
////    panGesture.delaysTouchesEnded=YES;
//    panGesture.minimumNumberOfTouches=2;
//    [self addGestureRecognizer:panGesture];
    
    
}

////缩放手势触发方法
-(void) pinchGesture:(id)sender
{
    _touchCan=NO;
    UIPinchGestureRecognizer *gesture = sender;
//    NSLog(@"pinchGesture!!!");
//    //手势改变时
//    if (gesture.state == UIGestureRecognizerStateChanged){

//    }
    _backImage.transform = CGAffineTransformScale(_backImage.transform, gesture.scale, gesture.scale);
    _paletteView.transform = CGAffineTransformScale(_paletteView.transform, gesture.scale, gesture.scale);
    if (gesture.state==UIGestureRecognizerStateEnded) {
        NSLog(@"end 缩放 end");
        lastScale=_backImage.frame.size.width/self.frame.size.width;
//        lastScale=round(_backImage.frame.size.width/self.frame.size.width);
//        NSLog(@"lastScale : %f",round(_backImage.frame.size.width/self.frame.size.width));
        _touchCan=YES;
    }
    gesture.scale = 1;
}
//拖动手势
-(void) panGesture:(id)sender
{
    _touchCan=NO;
    UIPanGestureRecognizer *gesture = sender;
//    NSLog(@"panGesture!!!");
    CGPoint translation = [gesture translationInView:self];
    CGPoint center = _backImage.center;
    center.x += translation.x;
    center.y += translation.y;
    _backImage.center = center;
    _paletteView.center = center;
    [gesture setTranslation:CGPointZero inView:self];
    if (gesture.state==UIGestureRecognizerStateEnded) {
        NSLog(@"end 拖动 end");
        _touchCan=YES;
    }
}

//#pragma mark  Popover support
//- (CGSize) contentSizeForViewInPopover
//{
//    return CGSizeMake(320, 416);
//}
//颜色和线宽
-(void)colorWidthButton:(UIButton *)sender
{
//    if (backBtnView) {
//        [backBtnView removeFromSuperview];
//        backBtnView=nil;
//        _doneBtn.backgroundColor=KSetColor(255, 136, 45);
//    }
//    
//    if (btnSelected==1) {
//        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectedColorR"];
//        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectedColorG"];
//        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectedColorB"];
//        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectedColorA"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        self.selectedColor=[UIColor whiteColor];
//    }
//    
//    
//    btnSelected=0;
//    _SegmentWidth=forwardWidth;
//    _colorResult=_forwardColor;
//    forwardStatus=0;
//    _forwardBtn.backgroundColor=KSetColor(255, 136, 45);
//    
//    if (picker) {
//        [picker removeFromSuperview];
//        picker=nil;
//    }
//    picker = [[KZColorPicker alloc] initWithFrame:CGRectMake(0, 64, self.superview.frame.size.width, self.superview.frame.size.height-64)];
//    //    picker.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    picker.selectedColor = self.selectedColor;
//    picker.oldColor = self.selectedColor;
//    picker.delegate=self;
//    [picker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
//    [self.superview addSubview:picker];
    _isAddViewShowing =!_isAddViewShowing;
    if (_isAddViewShowing) {
        [self createAddView];

    }else
    {
        [self dismiss];
    }
//    _colorResult=[UIColor blueColor];
    
}
- (void) pickerChanged:(KZColorPicker *)cp
{
    self.selectedColor = cp.selectedColor;
    //    [delegate defaultColorController:self didChangeColor:cp.selectedColor];
}

//橡皮擦
-(void)forwardBtn:(UIButton *)sender
{
//    if (_paletteView) {
//        [_paletteView myForwardLineAdd];
//    }
//    if (backBtnView) {
//        [backBtnView removeFromSuperview];
//        backBtnView=nil;
//        _doneBtn.backgroundColor=GWMColor(255, 136, 45);
//    }
    
//    if (forwardStatus==0) {
//        forwardWidth=_SegmentWidth;
//        _forwardColor=_colorResult;
////        _SegmentWidth=2;
//        _colorResult=[UIColor clearColor];//clearColor
//        NSLog(@"橡皮擦");
//        forwardStatus=1;
//        sender.backgroundColor=GWMColor(206, 206, 206);
//    }else{
//        _SegmentWidth=forwardWidth;
//        _colorResult=_forwardColor;
//        forwardStatus=0;
//        sender.backgroundColor=GWMColor(255, 136, 45);
//    }
    _colorResult=[UIColor clearColor];
}
//后退
-(void)backBtn:(UIButton *)sender
{
    if (backBtnView) {
        [backBtnView removeFromSuperview];
        backBtnView=nil;
        _doneBtn.backgroundColor=KSetColor(255, 136, 45);
    }
    
    if (forwardStatus==1) {
        _SegmentWidth=forwardWidth;
//    UIColor *temp=_colorResult;
        _colorResult=_forwardColor;
//    _forwardColor=temp;
        forwardStatus=0;
        _forwardBtn.backgroundColor=KSetColor(255, 136, 45);
    }
    
    
    if (_paletteView) {
        [_paletteView myLineFinallyRemove];
    }
}
//重做
-(void)clearBtn:(UIButton *)sender
{
    //保存
    _paletteView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-40);
    _backImage.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-40);
//    [self saveImageResult];
    
//    [_paletteView myalllineclear];
    if (_paletteView) {
        [_paletteView removeFromSuperview];
        drawViewPaint *paletteView=[[drawViewPaint alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-40)];
        paletteView.delegate=self;
        paletteView.backgroundColor=[UIColor clearColor];
        [self addSubview:paletteView];
        self.paletteView=paletteView;
    }
    
//    _colorResult=[UIColor blueColor];
//    [self removeAllThings];
    
}

//完成保存
-(void)doneButtonClicked:(int)tag
{
    //保存
    _paletteView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-40);
    _backImage.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-40);
//    [self saveImageResult];
    
    NSDictionary * mydic =[[NSUserDefaults standardUserDefaults]valueForKey:@"localSizeInPaint"];
    CGFloat widthInpaint = [[mydic objectForKey:@"width"] floatValue];
    CGFloat heightInpaint = [[mydic objectForKey:@"height"] floatValue];
    
//    CGSize sizeInPaint =CGSizeMake(widthInpaint, heightInpaint);
    NSLog(@"widthInpaint    %f",widthInpaint);
    NSLog(@"heightInpaint    %f",heightInpaint);

    if (tag==1) {
        //竖屏
//        UIGraphicsBeginImageContext(CGSizeMake(widthInpaint, heightInpaint-44));

        UIGraphicsBeginImageContext(CGSizeMake(self.frame.size.width, self.frame.size.height-44));
    }else if (tag==2)
    {
//        NSMutableDictionary * mydicviewSize=[[NSUserDefaults standardUserDefaults]valueForKey:@"localSizeViewSize"];
//
//        CGFloat widthviewSize = [[mydicviewSize objectForKey:@"width"] floatValue];
//        CGFloat heightviewSize = [[mydicviewSize objectForKey:@"height"] floatValue];
//        
//        widthInpaint= widthInpaint>widthviewSize?widthInpaint:widthviewSize;
//        heightInpaint= heightInpaint>heightviewSize?heightInpaint:heightviewSize;
        //放大沿用此方法
//        UIGraphicsBeginImageContext(CGSizeMake(widthInpaint, heightInpaint-44));

        //横屏
        UIGraphicsBeginImageContext(CGSizeMake(self.frame.size.width, self.frame.size.height-44));
    }
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage* image=UIGraphicsGetImageFromCurrentImageContext();
    //    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    self.imagePath=[self SaveImageTolocal:image];
    
    UIGraphicsEndImageContext();
   
    //通知代理
    if ([self.delegate respondsToSelector:@selector(saveImage:view:)]) {
        [self.delegate saveImage:self.imagePath view:self];
    }
    //通知代理
    if ([self.delegate respondsToSelector:@selector(reloadDrawFrame)]) {
        [self.delegate reloadDrawFrame];
    }
    
    
}

-(void)removeAllThings
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *temp=self.gestureRecognizers;
    for (int n=0; n<temp.count; n++) {
        UIGestureRecognizer *ges=temp[n];
        [self removeGestureRecognizer:ges];
    }
    [self setUpViews];
}

-(void)saveImageResult
{
//    [self setButtonsHidden:YES];
    //    [[self subviews] makeObjectsPerformSelector:@selector (setAlpha:)];
    
//    UIGraphicsBeginImageContext(self.bounds.size);
    UIGraphicsBeginImageContext(CGSizeMake(self.frame.size.width, self.frame.size.height-40));
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage* image=UIGraphicsGetImageFromCurrentImageContext();
//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    self.imagePath=[self SaveImageTolocal:image];
    
    UIGraphicsEndImageContext();
    //通知代理
    if ([self.delegate respondsToSelector:@selector(saveImage:view:)]) {
        [self.delegate saveImage:self.imagePath view:self];
    }
    
}
-(void)setButtonsHidden:(BOOL)hidden
{
    self.doneBtn.hidden=hidden;
    self.forwardBtn.hidden=hidden;
    self.backBtn.hidden=hidden;
    self.colorWidthButton.hidden=hidden;
}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
}
//保存发送图片到本地，返回绝对路径
-(NSString*) SaveImageTolocal:(UIImage *) img
{
    if(img==nil)
    {
        return nil;
    }
    NSString *path = @"";
    //    NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    NSString *dic = [NSHomeDirectory() stringByAppendingString:@"/Documents/pictureGra/"];
    
    //取出题号（即是当前页）
    
    int currentpage=9999;
    int studentNumber=9999;
    
    NSString * fileWithstudentNumber =[dic stringByAppendingString:[NSString stringWithFormat:@"%d",studentNumber]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    //    NSLog(@"图画的上一层地址 %@",dic);
    
    BOOL isDic;
    if(![fileManager fileExistsAtPath:dic isDirectory:&isDic]||(!isDic))
    {
        [fileManager createDirectoryAtPath:dic withIntermediateDirectories:YES attributes:nil error:nil];
    }
    BOOL res;
    if(![fileManager fileExistsAtPath:fileWithstudentNumber isDirectory:&res]||(!res))
    {
        [fileManager createDirectoryAtPath:fileWithstudentNumber withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //    NSLog(@"图画的下一层地址 %@",fileWithstudentNumber);
    
    path = [NSString stringWithFormat:@"%@/%d.jpg",fileWithstudentNumber,currentpage];
    
    if ([fileManager fileExistsAtPath:path]) {
        NSLog(@"以前就存在，删掉之前的");
        [fileManager removeItemAtPath:path error:nil];
    }
    
    NSLog(@"图画的最终的地址 %@",path);
    
    NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
    if(imgData)
    {
        [fileManager createFileAtPath:path contents:imgData attributes:nil];
    }
//    [self setButtonsHidden:NO];
    //    NSLog(@"pic:%@",path);
    return path;
}
#pragma mark -
//手指触屏开始
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self closeAddView];
    _isAddViewShowing =NO;
    isFirst=YES;
    UITouch* touch=[touches anyObject];
    if ((!_touchCan&&!_moveTouchCan)||touch.tapCount>1) {
        return;
    }
    
    if (_touchCan&&!_moveTouchCan) {
        if (backBtnView) {
            [backBtnView removeFromSuperview];
            backBtnView=nil;
            _doneBtn.backgroundColor=KSetColor(255, 136, 45);
        }
        
        
        [_paletteView clearArray];
        _MyBeganpoint=[touch locationInView:_paletteView ];
        //    [_paletteView Introductionpoint4:lastScale];//传比例20160926
        [_paletteView setSelectColor:_colorResult];
        [_paletteView Introductionpoint5:_SegmentWidth];
        [_paletteView Introductionpoint1];
        [_paletteView Introductionpoint3:_MyBeganpoint];
        //    NSLog(@"touch.tapCount : %lu",(unsigned long)touch.tapCount);
    }else if (!_touchCan&&_moveTouchCan)
    {
        UITouch* touch=[touches anyObject];
        CGPoint point = [touch locationInView:self];
        firstPoint = point;
//        NSLog(@"点击的点：%f ,%f",firstPoint.x,firstPoint.y);

    }
    
}
//手指移动时候发出
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (!_touchCan&&!_moveTouchCan) {
        return;
    }
    if (_touchCan&&!_moveTouchCan) {
        if (_isDelegateCan) {
            //代理
            if ([self.delegate respondsToSelector:@selector(setIsSubmimtCan)]) {
                [self.delegate setIsSubmimtCan];
            }
            _isDelegateCan =NO;
        }
        
        NSArray* MovePointArray=[touches allObjects];
        _MyMovepoint=[[MovePointArray objectAtIndex:0] locationInView:_paletteView];
        lastPoint =_MyMovepoint;
//        // 1.贝塞尔曲线
//        // 创建一个BezierPath对象
//        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
//        // 设置线宽
//        bezierPath.lineWidth = _SegmentWidth;
//        // 终点处理：设置结束点曲线
//        bezierPath.lineCapStyle = kCGLineCapRound;
//        // 拐角处理：设置两个连接点曲线
//        bezierPath.lineJoinStyle = kCGLineJoinRound;
//        // 设置线的颜色
//        [_colorResult setStroke];
//        // 设置填充颜色
//        [_colorResult setFill];
//        if (isFirst) {
//            // 设置线段的起始位置
//            [bezierPath moveToPoint:_MyBeganpoint];
//        }else
//        {
//            // 设置线段的起始位置
//            [bezierPath moveToPoint:lastPoint];
//        }
//        
//        // 添加点
//        [bezierPath addLineToPoint:_MyMovepoint];
//        // 闭合曲线：让起始点和结束点连接起来
//        [bezierPath closePath];
////        // 描绘
////        [bezierPath stroke];
////        // 填充
////        [bezierPath fill];
//        [_paletteView Introductionpoint6:bezierPath];
        [_paletteView Introductionpoint3:_MyMovepoint];
        [_paletteView setNeedsDisplay];

        isFirst=NO;
        //    NSLog(@"touchesMoved !!!");

    }else if (!_touchCan&&_moveTouchCan)
    {
        UITouch* touch=[touches anyObject];
        CGPoint point = [touch locationInView:self];
        CGFloat x =0.0;
        CGFloat y =0.0;
        
        x = point.x - firstPoint.x;
        y = point.y - firstPoint.y;
        
        if ([self.delegate respondsToSelector:@selector(changeImagePositionWithX:AndY:)]) {
            [self.delegate changeImagePositionWithX:x AndY:y];
        }

    }
    
}
//当手指离开屏幕时候
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"11111111");
    if (!_touchCan&&!_moveTouchCan) {
//        NSLog(@"22222222");
        return;
    }
    if (_touchCan&&!_moveTouchCan) {
        
        [_paletteView Introductionpoint2:_colorResult];
        [_paletteView setNeedsDisplay];
        
    }else if (!_touchCan&&_moveTouchCan)
    {
        

        if ([self.delegate respondsToSelector:@selector(reSetInputImageRect)]) {
            [self.delegate reSetInputImageRect];
        }

    }

    
}
//电话呼入等事件取消时候发出
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _touchCan=NO;
    [_paletteView resetColorsArray];
//    NSLog(@"touches Canelled");
}


-(void)resetButtonViews:(BOOL)canForward canBack:(BOOL)canBack canClear:(BOOL)canClear
{

}
#pragma delegate
-(void)saveColor:(UIColor *)color width:(int)width
{
    if (btnSelected==0) {
        _SegmentWidth=width;
        _red=color.red;
        _green=color.green;
        _blue=color.blue;
        _alp=color.alpha;
        _colorResult=color;
        NSLog(@"_SegmentWidth : %d",_SegmentWidth);
        NSLog(@"%@",_colorResult);
    }else{
        _backImage.image=[UIImage new];
        _backImage.backgroundColor=color;
    }
    
}

-(void)createAddView
{
    
//    // 背景
//    _maskView = [[UIView alloc] initWithFrame:CGRectMake(KWidth/2-150, 100, 170, 50)];
//    _maskView.backgroundColor = [UIColor whiteColor];
//    [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
//    [self.superview addSubview:_maskView];
//    _triangleFrame = CGRectMake(_width - 25, 0, 18, 14);
//    _width  =176;
//    
//    // 三角形
//    [self applytriangleView];
//
//    // item
//    for (int i =0; i<colorCount; i++) {
//        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame =CGRectMake(10+40*(i%colorCount), 10, 30, 30);
//        [btn setBackgroundColor:colorArr[i]];
//        [btn addTarget:self action:@selector(colorBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        btn.tag =i ;
//        [_maskView addSubview:btn];
//    }
    
//    _maskView.center = CGPointMake(25, KWidth/2+110);
}

-(void)colorBtnClicked:(UIButton *)sender
{
    UIButton * btn =(UIButton *)sender;
    NSInteger tag = btn.tag;
    _colorResult = colorArr[tag];
    [self closeAddView];
    _isAddViewShowing =NO;

}

-(void)closeAddView
{
    [self dismiss];
}
-(void)dismiss
{
    
    [UIView animateWithDuration:.25 animations:^{
        _contentView.alpha = 0.0f;
        _maskView.alpha = .0f;
    } completion:^(BOOL finished) {
        if (finished) {
            if (_maskView) {
                [_maskView removeFromSuperview];
                _maskView =nil;
            }
            if (_triangleView) {
                [_triangleView removeFromSuperview];
                _triangleView =nil;
            }
            _isAddViewShowing =NO;
        }
    }];
    
    
}

- (void)applytriangleView {
//    if (_triangleView == nil) {
//        _triangleView = [[UIView alloc] init];
//        _triangleView.backgroundColor = [UIColor whiteColor];
//        [self.superview addSubview:_triangleView];
//    }
//    _triangleFrame = CGRectMake( KWidth/2-120, 95, CGRectGetWidth(_triangleFrame), CGRectGetHeight(_triangleFrame));
//    _triangleView.frame = _triangleFrame;
//    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, &CGAffineTransformIdentity, CGRectGetWidth(_triangleFrame) / 2.0, 0);
//    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, 0, CGRectGetHeight(_triangleFrame));
//    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, CGRectGetWidth(_triangleFrame), CGRectGetHeight(_triangleFrame));
//    shaperLayer.path = path;
//    _triangleView.layer.mask = shaperLayer;
}




@end
