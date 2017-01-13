//
//  handschriftView.m
//  handschrift
//
//  Created by gongweimeng on 16/4/25.
//  Copyright © 2016年 YJ. All rights reserved.
//

#import "handschriftView.h"

@implementation handschriftView


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
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //用于答题方式跳转时：是否显示提示
    [userDefaults setObject:@"0" forKey:@"handWriten"];
    [userDefaults synchronize];
    NSString *temp=[userDefaults objectForKey:@"centerValueString"];
    if (temp.length>0) {
        self.Segment=temp.intValue/100;
        self.SegmentWidth=temp.intValue%100;
    }else{
        self.SegmentWidth=1.0;
        self.Segment=6;
    }
    UITabBarItem *item=[[UITabBarItem alloc]init];
    if (temp.length>0) {
        item.badgeValue=temp;
    }else{
        item.badgeValue=@"602";
    }
    self.item=item;
    self.backgroundColor=[UIColor whiteColor];
    self.userInteractionEnabled=YES;
    //画图区域
    Palette *paletteView=[[Palette alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-80)];
    paletteView.delegate=self;
    paletteView.backgroundColor=[UIColor whiteColor];
    [self addSubview:paletteView];
    self.paletteView=paletteView;
    //底部按钮
    
 
    
    //清空
    UIButton *doneBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-10-60, self.frame.size.height-55, 50, 30)];
    [doneBtn addTarget:self action:@selector(doneBtn:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundColor:KSetColor(206, 206, 206)];
    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSString *str=KSetString(@"local_clear");
    [doneBtn setTitle:str forState:UIControlStateNormal];
    CALayer *doneBtnLayer=[doneBtn layer];
    doneBtnLayer.cornerRadius=15;
    doneBtnLayer.borderColor=[KSetColor(206, 206, 206)CGColor];
    doneBtnLayer.borderWidth=1.0;
    doneBtnLayer.masksToBounds=YES;
    [self addSubview:doneBtn];
    self.doneBtn=doneBtn;
    
    //后退的前进
    UIImageView *middleImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-70, self.frame.size.height-55, 140, 40)];
    middleImageView.userInteractionEnabled=YES;

    [self addSubview:middleImageView];
    self.middleImageView=middleImageView;
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 0, 50, 30)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"handleft_N"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.middleImageView addSubview:backBtn];
    self.backBtn=backBtn;
    UIButton *forwardBtn=[[UIButton alloc]initWithFrame:CGRectMake(69, 0, 50, 30)];
    [forwardBtn setBackgroundImage:[UIImage imageNamed:@"handright_N"] forState:UIControlStateNormal];
    [forwardBtn addTarget:self action:@selector(forwardBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.middleImageView addSubview:forwardBtn];
    self.forwardBtn=forwardBtn;
    
    _haveWritten=NO;
}

//前进
-(void)forwardBtn:(UIButton *)sender
{
    if (_paletteView) {
        [_paletteView myForwardLineAdd];
    }
}
//后退
-(void)backBtn:(UIButton *)sender
{
    if (_paletteView) {
        [_paletteView myLineFinallyRemove];
    }
}
//清空
-(void)doneBtn:(UIButton *)sender
{
    
    if (_paletteView) {
        [_paletteView myalllineclear];
    }
    
}
-(void)saveImageResult
{
    if (!_haveWritten) {
        NSLog(@"未手写涂鸦");
        [self removeFromSuperview];
        return;
    }
//    [[self subviews] makeObjectsPerformSelector:@selector (setAlpha:)];

    UIGraphicsBeginImageContext(self.bounds.size);

    [_paletteView.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage* image=UIGraphicsGetImageFromCurrentImageContext();

    self.imagePath=[self SaveImageTolocal:image];
    UIGraphicsEndImageContext();
    //通知代理
    if ([self.delegate respondsToSelector:@selector(saveImage:view:)]) {
        [self.delegate saveImage:self.imagePath view:self];
    }
    //遍历view全部按钮在把他们改为１
//    for (UIView* temp in [self subviews])
//    {
//        [temp setAlpha:1.0];
//    }
    [self removeFromSuperview];
}
//颜色和线宽
-(void)colorWidthBtn:(UIButton *)sender
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%d",_Segment*100+_SegmentWidth] forKey:@"centerValueString"];
    [userDefaults synchronize];
    if (CWview) {
        [CWview removeFromSuperview];
        CWview=nil;
    }
    CWview=[[colorWidthView alloc]initWithFrame:self.bounds];
    CWview.delegate=self;
    NSLog(@"当前颜色和线宽：%d,%d",_Segment,_SegmentWidth);
    [self addSubview:CWview];
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
    NSString *dic = [NSHomeDirectory() stringByAppendingString:@"/Documents/pictureG/"];
    
    //取出题号（即是当前页）
    
    int currentpage=[[[NSUserDefaults standardUserDefaults]valueForKey:@"currentpage"] intValue];
    int studentNumber=[[[NSUserDefaults standardUserDefaults]valueForKey:@"66"] intValue];
    
    NSString * fileWithstudentNumber =[dic stringByAppendingString:[NSString stringWithFormat:@"%d",studentNumber]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    NSLog(@"图画的上一层地址 %@",dic);
    
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
    NSLog(@"图画的下一层地址 %@",fileWithstudentNumber);
    
    path = [NSString stringWithFormat:@"%@/%d.jpg",fileWithstudentNumber,currentpage];
    
    if ([fileManager fileExistsAtPath:path]) {
        NSLog(@"以前就存在，删掉之前的");
        [fileManager removeItemAtPath:path error:nil];
    }
    
    NSLog(@"图画的最终的地址 %@",path);
    
    NSData *imgData = UIImageJPEGRepresentation(img, 0.8);
    if(imgData)
    {
        [fileManager createFileAtPath:path contents:imgData attributes:nil];
    }
    
    //    NSLog(@"pic:%@",path);
    return path;
}
#pragma mark -
//手指开始触屏开始
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch* touch=[touches anyObject];
    [_paletteView clearArray];
    _MyBeganpoint=[touch locationInView:_paletteView ];
    [_paletteView Introductionpoint4:_Segment];
    [_paletteView Introductionpoint5:_SegmentWidth];
    [_paletteView Introductionpoint1];
    [_paletteView Introductionpoint3:_MyBeganpoint];
}
//手指移动时候发出
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    _haveWritten=YES;
    NSArray* MovePointArray=[touches allObjects];
    _MyMovepoint=[[MovePointArray objectAtIndex:0] locationInView:_paletteView];
    [_paletteView Introductionpoint3:_MyMovepoint];
    [_paletteView setNeedsDisplay];
}
//当手指离开屏幕时候
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_paletteView Introductionpoint2];
    [_paletteView setNeedsDisplay];
}
//电话呼入等事件取消时候发出
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touches Canelled");
}

//代理方法
-(void)CWView:(colorWidthView *)CWview setCWvalue:(int)CWvalue
{
    _Segment=CWvalue/100;
    _SegmentWidth=CWvalue%100;
    self.item.badgeValue=[NSString stringWithFormat:@"%d",CWvalue];
}

-(void)resetButtonViews:(BOOL)canForward canBack:(BOOL)canBack canClear:(BOOL)canClear
{
//    NSLog(@"11111111");
    if (canForward) {
        [self.forwardBtn setBackgroundImage:[UIImage imageNamed:@"handright_Y"] forState:UIControlStateNormal];
    }else{
        [self.forwardBtn setBackgroundImage:[UIImage imageNamed:@"handright_N"] forState:UIControlStateNormal];
    }
    if (canBack) {
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"handleft_Y"] forState:UIControlStateNormal];
    }else{
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"handleft_N"] forState:UIControlStateNormal];
    }
    if (canClear) {
        [self.doneBtn setBackgroundColor:[UIColor whiteColor]];
        [self.doneBtn setTitleColor:KSetColor(53, 199, 173) forState:UIControlStateNormal];
    }else{
        [self.doneBtn setBackgroundColor:KSetColor(206, 206, 206)];
        [self.doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    //用于答题方式跳转时：是否显示提示
    if (canClear) {
        _haveWritten=YES;
    }else{
        _haveWritten=NO;
    }
}
@end
