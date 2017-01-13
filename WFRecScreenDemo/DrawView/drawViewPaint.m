//
//  drawViewPaint.m
//  personalLetter
//
//  Created by gongweimeng on 16/8/31.
//  Copyright © 2016年 GWM. All rights reserved.
//

#import "drawViewPaint.h"

@implementation drawViewPaint

@synthesize x;
@synthesize y;

//0625
@synthesize myallline;
- (id)initWithFrame:(CGRect)frame {
    
    //	NSLog(@"initwithframe");
    self = [super initWithFrame:frame];
    if (self) {
        //        NSLog(@"11111111");
        // Initialization code.
        myallline=[[NSMutableArray alloc] initWithCapacity:10];
        _myallpoint=[[NSMutableArray alloc] initWithCapacity:10];
        _myallBezierPath =[[NSMutableArray alloc] initWithCapacity:10];
        _myallColor=[[NSMutableArray alloc] initWithCapacity:10];
        _myallwidth=[[NSMutableArray alloc] initWithCapacity:10];
        myforwardline=[[NSMutableArray alloc] initWithCapacity:10];
        myforwardcolor=[[NSMutableArray alloc] initWithCapacity:10];
        myforwardwidth=[[NSMutableArray alloc] initWithCapacity:10];
        myforwardpoint=[[NSMutableArray alloc] initWithCapacity:10];
        canF=NO;
        
        myAllScale=[[NSMutableArray alloc]initWithCapacity:10];
    }
    return self;
    
}
-(void)IntsegmentColor
{
    
    segmentColor=[selectedColor CGColor];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    @try {
//        NSLog(@"This is drawRect : %@ , %lu",myallline,(unsigned long)myallColor.count);
        [self resetLines];
//        NSLog(@"line : %@   Color : %@",myallline,myallColor);
        //获取上下文
        CGContextRef context=UIGraphicsGetCurrentContext();
        CGContextSetAllowsAntialiasing(context, YES);
        CGContextSetShouldAntialias(context, YES);
        //    CGContextSetAllowsFontSmoothing(context, YES);
        //    CGContextSetShouldSmoothFonts(context, YES);
        //设置笔冒
        CGContextSetLineCap(context, kCGLineCapRound);
        //设置画线的连接处　拐点圆滑
        CGContextSetLineJoin(context, kCGLineJoinRound);
//        if ([_myallBezierPath count]>0)
//        {
//            for (int i=0; i<_myallBezierPath.count; i++) {
//                UIBezierPath * path = _myallBezierPath[i];
//                [path stroke];
//                [path fill];
//            }
//        }
        //    NSLog(@"myforwardpoint : %@",myforwardpoint);
        //    NSLog(@"myallpoint: %@",myallpoint);
//        NSLog(@"%d*************%d",myallline.count,_myallColor.count);

        //画之前线
        if ([myallline count]>0){
            //        NSLog(@"11111");
            for (int i=0; i<[myallline count]; i++){
                NSArray* tempArray=[NSArray arrayWithArray:[myallline objectAtIndex:i]];
                //----------------------------------------------------------------
                //修改10.8 修改myallColor为单个颜色，蓝色,暂时屏蔽橡皮擦功能
                //若回复橡皮擦功能，还需要将myallColor等存储到本地去，详细见PaintViewController中的存储绘画的点
                if ([_myallColor count]>0)
                {
                    UIColor *tempColor=[_myallColor objectAtIndex:i];
                    segmentColor=[tempColor CGColor];
                    //此处有bug，可以借鉴Introductionpoint2:的解决方式，判断个数
//                    Intsegmentwidth=[[myallwidth objectAtIndex:i]floatValue]+1;
                }
                //固定颜色
//                segmentColor=[[UIColor blueColor] CGColor];
                Intsegmentwidth =2;
                //-----------------------------------------------------------------
                if ([tempArray count]>1){
                    CGContextBeginPath(context);
                    CGPoint myStartPoint=[[tempArray objectAtIndex:0] CGPointValue];
                    CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
                    
                    for (int j=0; j<[tempArray count]-1; j++){
                        CGPoint myEndPoint=[[tempArray objectAtIndex:j+1] CGPointValue];
                        //--------------------------------------------------------
                        //                    CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
                        if ([[UIColor colorWithCGColor:segmentColor] isEqual:[UIColor clearColor]]) {
                            //                        NSLog(@"CGContextClearRect1 !!!");
                            CGContextClearRect (context, CGRectMake(myEndPoint.x-7, myEndPoint.y-7, 14,14));
                        }else{
                            CGContextAddLineToPoint(context, myEndPoint.x,   myEndPoint.y);
                        }
                    }
                    CGContextSetStrokeColorWithColor(context, segmentColor);
                    //-------------------------------------------------------
                    CGContextSetLineWidth(context, Intsegmentwidth);
                    CGContextStrokePath(context);
                }
            }
        }
        //画当前的线
        if ([_myallpoint count]>1){
//            NSLog(@"myallpoint1: %@",myallpoint);
            canF=NO;
            CGContextBeginPath(context);
            //-------------------------
            //起点
            //------------------------
            CGPoint myStartPoint=[[_myallpoint objectAtIndex:0]   CGPointValue];
            CGContextMoveToPoint(context,    myStartPoint.x, myStartPoint.y);
            
             //修改10.8 修改myallColor为单个颜色，蓝色,暂时屏蔽橡皮擦功能
            //在颜色和画笔大小数组里面取不相应的值
            UIColor *tempColor=[_myallColor lastObject];
            segmentColor=[tempColor CGColor];
            Intsegmentwidth=[[_myallwidth lastObject]floatValue]+1;
//            segmentColor=[[UIColor blueColor] CGColor];
            Intsegmentwidth =2;

            
            //把move的点全部加入　数组
            for (int i=0; i<[_myallpoint count]-1; i++){
                CGPoint myEndPoint=  [[_myallpoint objectAtIndex:i+1] CGPointValue];
                
                if ([[UIColor colorWithCGColor:segmentColor] isEqual:[UIColor clearColor]]) {
                    //                NSLog(@"CGContextClearRect2 !!!");
                    CGContextClearRect (context, CGRectMake(myEndPoint.x-7, myEndPoint.y-7, 14, 14));
                }else{
                    CGContextAddLineToPoint(context, myEndPoint.x,   myEndPoint.y);
                }
                
            }
            //-------------------------------------------
            CGContextSetStrokeColorWithColor(context, segmentColor);
            CGContextSetFillColorWithColor (context,  segmentColor);
            
            //-------------------------------------------
            //绘制画笔宽度
            CGContextSetLineWidth(context, Intsegmentwidth);
            //把数组里面的点全部画出来
            CGContextStrokePath(context);
            
        }
         
    } @catch (NSException *exception) {
        NSLog(@"exception: %@",exception);
    } @finally {
        
    }
    
    
}
//===========================================================
//初始化
//===========================================================
-(void)Introductionpoint1
{
//    NSLog(@"in init allPoint");
//    _myallpoint=[[NSMutableArray alloc] initWithCapacity:10];
    [_myallpoint removeAllObjects];
}
//===========================================================
//把画过的当前线放入　存放线的数组
//===========================================================
-(void)Introductionpoint2:(UIColor*)sender
{
    //    NSLog(@"myallpoint: %@",myallpoint);
    [myallline addObject:[_myallpoint copy]];
    //bug修复
    if (myallline.count>_myallColor.count) {
        [_myallColor addObject:sender];
    }
    
}
-(void)Introductionpoint3:(CGPoint)sender
{
    NSValue* pointvalue=[NSValue valueWithCGPoint:sender];
    [_myallpoint addObject:pointvalue ];
}
-(void)Introductionpoint6:(UIBezierPath*)sender
{
    [_myallBezierPath addObject:sender];
}


//===========================================================
//接收颜色segement反过来的值
//===========================================================
-(void)Introductionpoint4:(CGFloat)sender
{
    NSNumber* Numbersender= [NSNumber numberWithInt:sender];
    [_myallColor addObject:Numbersender];
    [myAllScale addObject:[NSString stringWithFormat:@"%f",sender]];
}
-(void)setSelectColor:(UIColor *)sender
{
    [_myallColor addObject:sender];
}
//===========================================================
//接收线条宽度按钮反回来的值
//===========================================================
-(void)Introductionpoint5:(int)sender
{
    //	NSLog(@"Palette sender:%i", sender);
    NSNumber* Numbersender= [NSNumber numberWithInt:sender];
    [_myallwidth addObject:Numbersender];
}
//===========================================================
//清屏按钮
//===========================================================
-(void)myalllineclear
{

    if ([myallline count]>0)
    {
        [myallline removeAllObjects];
        [_myallColor removeAllObjects];
        [_myallwidth removeAllObjects];
        [_myallpoint removeAllObjects];
        myallline=[[NSMutableArray alloc] initWithCapacity:10];
        _myallColor=[[NSMutableArray alloc] initWithCapacity:10];
        _myallwidth=[[NSMutableArray alloc] initWithCapacity:10];
        myforwardpoint=[[NSMutableArray alloc] initWithCapacity:10];
        
        [myforwardline removeAllObjects];
        [myforwardcolor removeAllObjects];
        [myforwardwidth removeAllObjects];
        myforwardline=[[NSMutableArray alloc]initWithCapacity:10];
        myforwardcolor=[[NSMutableArray alloc]initWithCapacity:10];
        myforwardwidth=[[NSMutableArray alloc]initWithCapacity:10];
        myforwardpoint=[[NSMutableArray alloc]initWithCapacity:10];
        
        
        
        [self setNeedsDisplay];
    }
}
//===========================================================
//撤销
//===========================================================
-(void)myLineFinallyRemove
{
    if ([myallline count]>0)
    {
        [myforwardline addObject:[[myallline lastObject] copy]];
        [myforwardwidth addObject:[_myallwidth lastObject]];
        [myforwardcolor addObject:[_myallColor lastObject]];
        [myforwardpoint addObject:[_myallpoint copy]];
        
        
        [myallline  removeLastObject];
        [_myallColor removeLastObject];
        [_myallwidth removeLastObject];
        [_myallpoint removeAllObjects];
        //         NSLog(@"添加:%@",[myforwardline lastObject]);
    }
    
    
    [self setNeedsDisplay];
}

//===========================================================
//-(void)myrubberseraser
//{
//	segmentColor=[[UIColor whiteColor]CGColor];
//}
-(void)button
{
    NSLog(@"button");
    
    //[self setNeedsDisplay];
}

-(void)myForwardLineAdd
{
    if (myforwardline.count>0) {
        [myallline addObject:[myforwardline lastObject]];
        [_myallColor addObject:[myforwardcolor lastObject]];
        [_myallwidth addObject:[myforwardwidth lastObject]];
        _myallpoint=[[NSMutableArray alloc]initWithArray:[myforwardpoint lastObject]];
        [myforwardwidth removeLastObject];
        [myforwardline removeLastObject];
        [myforwardcolor removeLastObject];
        [myforwardpoint removeLastObject];
        //        NSLog(@"..:%@,%lu",[myallline lastObject],(unsigned long)myallline.count);
    }
    [self setNeedsDisplay];
}
-(void)clearArray
{
    if (myforwardline.count>0) {
        [myforwardpoint removeAllObjects];
        [myforwardwidth removeAllObjects];
        [myforwardline removeAllObjects];
        [myforwardcolor removeAllObjects];
    }
}
-(void)resetColorsArray
{
    NSLog(@"%lu  %lu",(unsigned long)myallline.count,(unsigned long)_myallColor.count);
    if (myallline.count==0) {
        [_myallColor removeAllObjects];
    }else{
        if (_myallColor.count>myallline.count) {
            [_myallColor removeObjectsInRange:NSMakeRange(myallline.count, _myallColor.count-myallline.count)];
            NSLog(@"myallColor: %@",_myallColor);
        }
    }
    [_myallpoint removeAllObjects];
    [self setNeedsDisplay];
}
-(void)resetLines
{
    for (int n=0; n<myallline.count; n++) {
        NSArray *temp=myallline[n];
        if (temp.count<2) {
            [myallline removeObjectAtIndex:n];
            if (_myallColor.count>n) {
                [_myallColor removeObjectAtIndex:n];
            }
        }
    }
}
@end
