//
//  handschriftViewHomeWork.m
//  headTeacherAssistant
//
//  Created by 王飞 on 16/9/7.
//  Copyright © 2016年 YJ. All rights reserved.
//

#import "handschriftViewEsayAnswer.h"

@implementation handschriftViewEsayAnswer

{
    NSTimer *touchTimer;
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
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //用于答题方式跳转时：是否显示提示
    [userDefaults setObject:@"0" forKey:@"handWriten"];
    [userDefaults synchronize];
    NSString *temp=[userDefaults objectForKey:@"centerValueString"];
    if (temp.length>0) {
        self.Segment=temp.intValue/100;
        self.SegmentWidth=temp.intValue%100;
    }else{
        self.SegmentWidth=2.0;
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
    PaletteEsayAnswer *paletteView=[[PaletteEsayAnswer alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-80)];
    paletteView.delegate=self;
    paletteView.backgroundColor=[UIColor clearColor];
    [self addSubview:paletteView];
    self.paletteView=paletteView;
    
    haveWritten=NO;
    
    self.linePathArray=[[NSMutableArray alloc]init];
}
-(void)spaceBtn:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(spaceText)]) {
        [self.delegate spaceText];
    }
}
-(void)enterBtn:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(enterLines)]) {
        [self.delegate enterLines];
    }
}
//前进(撤销)
-(void)forwardBtn:(UIButton *)sender
{
//    if ([self.delegate respondsToSelector:@selector(cancelDeleteLines)]) {
//        [self.delegate cancelDeleteLines];
//    }
    
    if ([self.delegate respondsToSelector:@selector(deleteLines)]) {
        [self.delegate deleteLines];
    }
    
}
//删除
-(void)backBtn:(UIButton *)sender
{
    
//    if ([self.delegate respondsToSelector:@selector(deleteLines)]) {
//        [self.delegate deleteLines];
//    }
    
    if ([self.delegate respondsToSelector:@selector(deleteAllLines)]) {
        [self.delegate deleteAllLines];
    }
}
//保存一下当前，然后情况
-(void)doneBtn:(UIButton *)sender
{
    
    //0625
    if (touchTimer) {
        [touchTimer invalidate];
        touchTimer=nil;
    }
    self.resultLines=_paletteView.myallline;
    //    NSLog(@"resultLines : %@",self.resultLines);
    if (!haveWritten) {
        NSLog(@"未手写涂鸦");
        //        [self removeFromSuperview];
        return;
    }
    //    UIGraphicsBeginImageContext(self.bounds.size);
    //    [_paletteView.layer renderInContext:UIGraphicsGetCurrentContext()];
    //    UIImage* image=UIGraphicsGetImageFromCurrentImageContext();
    //    self.imagePath=[self SaveImageTolocal:image];
    //    UIGraphicsEndImageContext();
    //通知代理
    if ([self.delegate respondsToSelector:@selector(saveImage:view:)]) {
        [self.delegate saveImage:self.imagePath view:self];
    }
    if (_paletteView) {
        [_paletteView myalllineclear];
    }
    
    if (_linePathArray) {
        [_linePathArray removeAllObjects];
    }
}
-(void)saveImageResult
{
    if (!haveWritten) {
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
    NSString *dic = [NSHomeDirectory() stringByAppendingString:@"/Documents/picture/"];
    
    //取出题号（即是当前页）
    
    int currentpage=[[[NSUserDefaults standardUserDefaults]valueForKey:@"currentpage"] intValue];
//    NSString* studentNumber=[[NSUserDefaults standardUserDefaults]valueForKey:myInputNameEasyAnswer];
    
    NSString * fileWithstudentNumber =[dic stringByAppendingString:[NSString stringWithFormat:@"%@",@"123"]];
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
    
    NSLog(@"图画的最终的地址12 %@",path);
    
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
    if (touchTimer) {
        [touchTimer invalidate];
        touchTimer=nil;
    }
    
    
    haveWritten=YES;
    UITouch* touch=[touches anyObject];
    [_paletteView clearArray];
    _MyBeganpoint=[touch locationInView:_paletteView ];
    [_paletteView Introductionpoint4:_Segment];
    [_paletteView Introductionpoint5:_SegmentWidth];
    [_paletteView Introductionpoint1];
    [_paletteView Introductionpoint3:_MyBeganpoint];
    
    
    
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",_MyBeganpoint.x],@"pointx",[NSString stringWithFormat:@"%f",_MyBeganpoint.y],@"pointy",@"1",@"status", nil];
    [_linePathArray addObject:dic];
}
//手指移动时候发出
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(setstatusToInput)]) {
        [self.delegate setstatusToInput];
    }
    NSArray* MovePointArray=[touches allObjects];
    _MyMovepoint=[[MovePointArray objectAtIndex:0] locationInView:_paletteView];
    [_paletteView Introductionpoint3:_MyMovepoint];
    [_paletteView setNeedsDisplay];
    
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",_MyMovepoint.x],@"pointx",[NSString stringWithFormat:@"%f",_MyMovepoint.y],@"pointy",@"2",@"status", nil];
    [_linePathArray addObject:dic];
    
}
//当手指离开屏幕时候
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_paletteView Introductionpoint2];
    [_paletteView setNeedsDisplay];
    
    
    CGPoint position = [touches.anyObject locationInView:_paletteView];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",position.x],@"pointx",[NSString stringWithFormat:@"%f",position.y],@"pointy",@"3",@"status", nil];
    [_linePathArray addObject:dic];
    
    if (touchTimer) {
        [touchTimer invalidate];
        touchTimer=nil;
    }
    touchTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doneBtn:) userInfo:nil repeats:NO];
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
        [self.doneBtn setTitleColor:KSetColor(0, 145, 208) forState:UIControlStateNormal];
    }else{
        [self.doneBtn setBackgroundColor:KSetColor(206, 206, 206)];
        [self.doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    //用于答题方式跳转时：是否显示提示
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if (canClear) {
        haveWritten=YES;
        [userDefault setObject:@"1" forKey:@"handWriten"];
    }else{
        haveWritten=NO;
        [userDefault setObject:@"0" forKey:@"handWriten"];
    }
    [userDefault synchronize];
}


@end
