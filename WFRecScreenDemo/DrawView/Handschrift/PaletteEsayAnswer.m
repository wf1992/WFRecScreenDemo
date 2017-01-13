//
//  PaletteEsayAnswer.m
//  headTeacherAssistant
//
//  Created by 王飞 on 16/9/7.
//  Copyright © 2016年 YJ. All rights reserved.
//

#import "PaletteEsayAnswer.h"

@implementation PaletteEsayAnswer
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
        myallColor=[[NSMutableArray alloc] initWithCapacity:10];
        myallwidth=[[NSMutableArray alloc] initWithCapacity:10];
        myforwardline=[[NSMutableArray alloc] initWithCapacity:10];
        myforwardcolor=[[NSMutableArray alloc] initWithCapacity:10];
        myforwardwidth=[[NSMutableArray alloc] initWithCapacity:10];
        myforwardpoint=[[NSMutableArray alloc] initWithCapacity:10];
        canF=NO;
    }
    return self;
    
}
-(void)IntsegmentColor
{
    switch (Intsegmentcolor)
    {
        case 0:
            segmentColor=[[UIColor blackColor] CGColor];
            break;
        case 1:
            segmentColor=[[UIColor redColor] CGColor];
            break;
        case 2:
            segmentColor=[[UIColor colorWithRed:28/255.0 green:198/255.0 blue:8/255.0 alpha:1.0] CGColor];
            
            break;
        case 3:
            segmentColor=[[UIColor colorWithRed:11/255.0 green:56/255.0 blue:150/255.0 alpha:1.0] CGColor];
            break;
        case 4:
            segmentColor=[[UIColor colorWithRed:249/255.0 green:0/255.0 blue:9/255.0 alpha:1.0] CGColor];
            break;
        case 5:
            segmentColor=[[UIColor orangeColor] CGColor];
            break;
        case 6:
            segmentColor=[[UIColor blackColor] CGColor];
            break;
        case 7:
            segmentColor=[[UIColor purpleColor]CGColor];
            break;
        case 8:
            
            segmentColor=[[UIColor brownColor]CGColor];
            break;
        case 9:
            segmentColor=[[UIColor magentaColor]CGColor];
            break;
        case 10:
            segmentColor=[[UIColor whiteColor]CGColor];
            break;
            
        default:
            break;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //	NSLog(@"This is drawRect ");
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
    
    //    NSLog(@"myforwardpoint : %@",myforwardpoint);
    //    NSLog(@"myallpoint: %@",myallpoint);
    //画之前线
    if ([myallline count]>0)
    {
        //        NSLog(@"11111");
        for (int i=0; i<[myallline count]; i++)
        {
            NSArray* tempArray=[NSArray arrayWithArray:[myallline objectAtIndex:i]];
            //----------------------------------------------------------------
            if ([myallColor count]>0)
            {
                Intsegmentcolor=[[myallColor objectAtIndex:i] intValue];
                Intsegmentwidth=[[myallwidth objectAtIndex:i]floatValue]+1;
            }
            //-----------------------------------------------------------------
            if ([tempArray count]>1)
            {
                CGContextBeginPath(context);
                CGPoint myStartPoint=[[tempArray objectAtIndex:0] CGPointValue];
                CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
                
                for (int j=0; j<[tempArray count]-1; j++)
                {
                    CGPoint myEndPoint=[[tempArray objectAtIndex:j+1] CGPointValue];
                    //--------------------------------------------------------
                    CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
                }
                [self IntsegmentColor];
                CGContextSetStrokeColorWithColor(context, segmentColor);
                //-------------------------------------------------------
                CGContextSetLineWidth(context, Intsegmentwidth);
                CGContextStrokePath(context);
            }
        }
        //        NSLog(@"draw:%@,%lu",[myallline lastObject],(unsigned long)myallline.count);
        
    }
    //画当前的线
    if ([myallpoint count]>1)
    {
        //        NSLog(@"22222");
        canF=NO;
        
        CGContextBeginPath(context);
        //-------------------------
        //起点
        //------------------------
        CGPoint myStartPoint=[[myallpoint objectAtIndex:0]   CGPointValue];
        CGContextMoveToPoint(context,    myStartPoint.x, myStartPoint.y);
        //把move的点全部加入　数组
        for (int i=0; i<[myallpoint count]-1; i++)
        {
            CGPoint myEndPoint=  [[myallpoint objectAtIndex:i+1] CGPointValue];
            CGContextAddLineToPoint(context, myEndPoint.x,   myEndPoint.y);
        }
        //在颜色和画笔大小数组里面取不相应的值
        Intsegmentcolor=[[myallColor lastObject] intValue];
        Intsegmentwidth=[[myallwidth lastObject]floatValue]+1;
        
        //-------------------------------------------
        //绘制画笔颜色
        [self IntsegmentColor];
        CGContextSetStrokeColorWithColor(context, segmentColor);
        CGContextSetFillColorWithColor (context,  segmentColor);
        
        //-------------------------------------------
        //绘制画笔宽度
        CGContextSetLineWidth(context, Intsegmentwidth);
        //把数组里面的点全部画出来
        CGContextStrokePath(context);
    }
    //    [self resetButtons];
}
//===========================================================
//初始化
//===========================================================
-(void)Introductionpoint1
{
    NSLog(@"in init allPoint");
    myallpoint=[[NSMutableArray alloc] initWithCapacity:10];
}
//===========================================================
//把画过的当前线放入　存放线的数组
//===========================================================
-(void)Introductionpoint2
{
    //    NSLog(@"myallpoint: %@",myallpoint);
    [myallline addObject:[myallpoint copy]];
}
-(void)Introductionpoint3:(CGPoint)sender
{
    NSValue* pointvalue=[NSValue valueWithCGPoint:sender];
    [myallpoint addObject:pointvalue ];
}
//===========================================================
//接收颜色segement反过来的值
//===========================================================
-(void)Introductionpoint4:(int)sender
{
    //	NSLog(@"Palette sender:%i", sender);
    NSNumber* Numbersender= [NSNumber numberWithInt:sender];
    [myallColor addObject:Numbersender];
}
//===========================================================
//接收线条宽度按钮反回来的值
//===========================================================
-(void)Introductionpoint5:(int)sender
{
    //	NSLog(@"Palette sender:%i", sender);
    NSNumber* Numbersender= [NSNumber numberWithInt:sender];
    [myallwidth addObject:Numbersender];
}
//===========================================================
//清屏按钮
//===========================================================
-(void)myalllineclear
{
    if ([myallline count]>0)
    {
        [myallline removeAllObjects];
        [myallColor removeAllObjects];
        [myallwidth removeAllObjects];
        [myallpoint removeAllObjects];
        myallline=[[NSMutableArray alloc] initWithCapacity:10];
        myallColor=[[NSMutableArray alloc] initWithCapacity:10];
        myallwidth=[[NSMutableArray alloc] initWithCapacity:10];
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
    //    [self resetButtons];
}
//===========================================================
//撤销
//===========================================================
-(void)myLineFinallyRemove
{
    if ([myallline count]>0)
    {
        [myforwardline addObject:[[myallline lastObject] copy]];
        [myforwardwidth addObject:[myallwidth lastObject]];
        [myforwardcolor addObject:[myallColor lastObject]];
        [myforwardpoint addObject:[myallpoint copy]];
        
        
        [myallline  removeLastObject];
        [myallColor removeLastObject];
        [myallwidth removeLastObject];
        [myallpoint removeAllObjects];
        //         NSLog(@"添加:%@",[myforwardline lastObject]);
    }
    
    //    [self resetButtons];
    
    [self setNeedsDisplay];
}
//===========================================================
//橡皮擦　segmentColor=[[UIColor whiteColor]CGColor];
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
        [myallColor addObject:[myforwardcolor lastObject]];
        [myallwidth addObject:[myforwardwidth lastObject]];
        myallpoint=[[NSMutableArray alloc]initWithArray:[myforwardpoint lastObject]];
        [myforwardwidth removeLastObject];
        [myforwardline removeLastObject];
        [myforwardcolor removeLastObject];
        [myforwardpoint removeLastObject];
        //        NSLog(@"..:%@,%lu",[myallline lastObject],(unsigned long)myallline.count);
    }
    //    [self resetButtons];
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
-(void)resetButtons
{
    //通知代理
    if ([self.delegate respondsToSelector:@selector(resetButtonViews:canBack:canClear:)]) {
        BOOL canB=NO;
        BOOL canC=NO;
        if (myallline.count>0) {
            canC=YES;
            canB=YES;
        }
        if (myforwardline.count>0) {
            canF=YES;
        }
        
        [self.delegate resetButtonViews:canF canBack:canB canClear:canC];
    }
}


@end
