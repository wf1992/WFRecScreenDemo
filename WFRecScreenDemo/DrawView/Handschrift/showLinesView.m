//
//  showLinesView.m
//  YJEasyAnswer
//
//  Created by gongweimeng on 16/8/25.
//  Copyright © 2016年 YJ. All rights reserved.
//

#import "showLinesView.h"
#define drawHeight  25 //手写保存尺寸0625
#define cursorY 2.5
@implementation showLinesView
{
    NSMutableArray *myallline;
    int pageNumber;
    CGFloat scale;
    NSMutableArray *lastLines;
    CGFloat defWitdh;
    
    
    CGFloat realX;
    CGFloat realY;
    
    //光标
    NSThread *drawCursor;
    UIView *CursorView;
    NSMutableDictionary *enterDic;
    
}
@synthesize pathArray;
@synthesize enterDic;
@synthesize maxHeight;
-(id)initRects:(CGRect)rect lines:(NSMutableArray *)lines
{
    self=[super initWithFrame:rect];
    if (self) {

        enterDic=[[NSMutableDictionary alloc]init];
        pathArray=[[NSMutableArray alloc]init];
        lastLines=[[NSMutableArray alloc]init];
        pageNumber=0;
        scale=0.125;
        defWitdh=self.frame.size.width*scale;
        myallline=[[NSMutableArray alloc]init];
        if (lines.count>0) {
             [myallline addObject:lines];
        }
        self.backgroundColor=[UIColor whiteColor];
        CursorView = [[UIView alloc] initWithFrame:CGRectMake(10, 5+cursorY, 1, 20)];  //光标以及线程
        CursorView.backgroundColor = [UIColor grayColor];
        [self addSubview:CursorView];
        
        drawCursor = [[NSThread alloc]initWithTarget:self selector:@selector(drawCursor:) object:self];
        [drawCursor start];
        
        for (int n=drawHeight+5; n<rect.size.height;) {
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, n, rect.size.width, 1)];
            lab.backgroundColor=KSetColor(239, 239, 239);
            [self addSubview:lab];
            n=n+drawHeight+5;
        }
    }
    return self;
}
-(void)drawCursor:(NSThread *)Cursor{
    
    while (![drawCursor isCancelled]) {
        [NSThread sleepForTimeInterval:0.5];
        [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
    }
}
-(void)updateUI{
    //    NSLog(@"1111111：%d",FlagCursor);
    if (CursorView.hidden) {
        CursorView.hidden = NO;
    }else{
        CursorView.hidden = YES;
    }
}
- (void)drawRect:(CGRect)rect
{
//    	NSLog(@"This is drawRect : %@ ",myallline);
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

    realX=5;
    realY=5;
    if ([pathArray count]>0)
    {
        for (int i=0; i<[pathArray count]; i++)
        {
            BOOL isWhite=NO;
            NSArray* tempArray=[NSArray arrayWithArray:[pathArray objectAtIndex:i]];
            if (tempArray.count>0) {
                CGPoint scalePoint=[self getPointFromArray:tempArray];//x和y最小的点
                if (tempArray.count<5) {
                    continue;
                }
                CGFloat delY =0.0;
                scale=drawHeight/[self getHeightFromArray:tempArray];//高度比例
                if ([self getHeightFromArray:tempArray]<drawHeight) {
                    scale=0.25;
                    delY=(drawHeight-[self getHeightFromArray:tempArray])/2;
                    if ([self getWidthFromArray:tempArray]<1.5*drawHeight) {
                        scale=0.5;
                    }
                }
                //NSLog(@"scale: %f",scale);
                if (i>0) {
                    NSArray *before=pathArray[i-1];
                    CGFloat beforeH=[self getHeightFromArray:before];
                    CGFloat beforeHS=drawHeight/beforeH;
                    CGFloat beforeWS=[self getWidthFromArray:before];
                    NSLog(@"beforeHS : %f",beforeHS);
                    if (beforeH<drawHeight) {
                        beforeHS=0.25;
                        if ([self getWidthFromArray:before]<1.5*drawHeight) {
                            beforeHS=0.5;
                        }
                    }
                    CGFloat beforeW=beforeHS*beforeWS;
                    NSLog(@"realW : %f",beforeW);
                    realX=realX+beforeW+3;
                }
                if (realX>self.frame.size.width-[self getWidthFromArray:tempArray]*scale-10) {
                    realY=realY+drawHeight+5;
                    realX=5;
                }
                
                //换行
                if (i==pathArray.count-1) {
                    if (i==0) {
                        int number=[[enterDic objectForKey:[NSString stringWithFormat:@"%d",i]] intValue];
                        if (number>0) {
                            realY=realY+number*(drawHeight+5);
                            realX=5;
                            CursorView.frame=CGRectMake(realX+[self getWidthFromArray:tempArray]*scale+8, realY+cursorY, 1, 20);
                        }else{
                            CursorView.frame=CGRectMake(realX+[self getWidthFromArray:tempArray]*scale+8, realY+cursorY, 1, 20);
                        }
                    }else{
                        int number=[[enterDic objectForKey:[NSString stringWithFormat:@"%d",i]] intValue];
                        if (number>0) {
                            realY=realY+number*(drawHeight+5);
                            realX=5;
                            CursorView.frame=CGRectMake(10, realY+cursorY, 1, 20);
                        }else{
                            CursorView.frame=CGRectMake(realX+[self getWidthFromArray:tempArray]*scale+8, realY+cursorY, 1, 20);
                        }
                        
                    }
                    
                }else{
                    int number=[[enterDic objectForKey:[NSString stringWithFormat:@"%d",i]] intValue];
                    if (number>0) {
                        realY=realY+number*(drawHeight+5);
                        realX=5;
                    }else{
                        
                    }
                    CursorView.frame=CGRectMake(realX+[self getWidthFromArray:tempArray]*scale+8, realY+cursorY, 1, 20);
                }
                

                
                CGFloat minX=scalePoint.x;
                CGFloat minY=scalePoint.y;
//                if ([self getHeightFromArray:tempArray]<drawHeight*3+10) {
//                    minY=minY/2+drawHeight/2;
//                }
                if ([tempArray count]>1)
                {
                    NSDictionary *dic0=[tempArray objectAtIndex:0];
                    CGContextBeginPath(context);
                    CGPoint myStartPoint=CGPointMake([[dic0 objectForKey:@"pointx"] floatValue], [[dic0 objectForKey:@"pointy"] floatValue]);
                    
                    CGContextMoveToPoint(context, (myStartPoint.x-minX)*scale+realX, (myStartPoint.y-minY)*scale+realY+delY);
                    
                    for (int j=0; j<[tempArray count]-1; j++)
                    {
                        NSDictionary *dic=[tempArray objectAtIndex:j+1];
                        CGPoint myEndPoint=CGPointMake([[dic objectForKey:@"pointx"] floatValue], [[dic objectForKey:@"pointy"] floatValue]);
                        if ([[dic objectForKey:@"status"] intValue]==1) {
                            CGContextMoveToPoint(context, (myEndPoint.x-minX)*scale+realX, (myEndPoint.y-minY)*scale+realY+delY);
                        }else{
                            CGContextAddLineToPoint(context, (myEndPoint.x-minX)*scale+realX,(myEndPoint.y-minY)*scale+realY+delY);
                        }
                        //--------------------------------------------------------
                        if ([[dic objectForKey:@"color"] intValue]==1) {
                            isWhite=YES;
                        }
                    }
                    
                    //换行
                    if (i==pathArray.count-1) {
                        int lastNum=[[enterDic objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)pathArray.count]] intValue];
                        if (lastNum>0) {
                            realY=realY+lastNum*(drawHeight+5);
                            CursorView.frame=CGRectMake(10, realY+cursorY, 1, 20);
                        }else{
                            CursorView.frame=CGRectMake(realX+[self getWidthFromArray:tempArray]*scale+8, realY+cursorY, 1, 20);
                        }
                    }
                    
                    
                    if (isWhite) {
                        CGContextSetStrokeColorWithColor(context, [[UIColor clearColor] CGColor]);
                    }else{
                        CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
                    }
                    //-------------------------------------------------------
                    CGContextSetLineWidth(context, 1.0);
                    CGContextStrokePath(context);
                }
            }else{
            }
        }
        //        NSLog(@"draw:%@,%lu",[myallline lastObject],(unsigned long)myallline.count);
        maxHeight=realY+drawHeight+5;
    }else{
        int number=[[enterDic objectForKey:[NSString stringWithFormat:@"%d",0]] intValue];
        if (number>0) {
            realY=realY+number*(drawHeight+5);
            realX=5;
            CursorView.frame=CGRectMake(10, realY+cursorY, 1, 20);
        }else{
            CursorView.frame=CGRectMake(10, 5+cursorY, 1, 20);
        }
        maxHeight=realY+drawHeight+5;
    }
}
-(CGFloat)getWidthFromArray:(NSArray *)arr
{
    CGFloat max=0.0;
    CGFloat min=0.0;
    if (arr.count>0) {
        NSDictionary *dic=arr[0];
        max=[[dic objectForKey:@"pointx"] floatValue];
        min=[[dic objectForKey:@"pointx"] floatValue];
    }
    
    for (int n=0; n<arr.count; n++) {
        CGFloat tempP=[[arr[n] objectForKey:@"pointx"] floatValue];
        if (tempP<min) {
            min=tempP;
        }
    }
    for (int n=0; n<arr.count; n++) {
        CGFloat tempP=[[arr[n] objectForKey:@"pointx"] floatValue];
        if (tempP>max) {
            max=tempP;
        }
    }
    
    //NSLog(@"X最大差：%f",(max-min));
    return (max-min);
}
-(CGFloat)getHeightFromArray:(NSArray *)arr
{
    CGFloat maxY=0.0;
    CGFloat minY=0.0;
    if (arr.count>0) {
        NSDictionary *dic=arr[0];
        maxY=[[dic objectForKey:@"pointy"] floatValue];
        minY=[[dic objectForKey:@"pointy"] floatValue];
    }
    
    for (int n=0; n<arr.count; n++) {
        CGFloat tempP=[[arr[n] objectForKey:@"pointy"] floatValue];
        if (tempP<minY) {
            minY=tempP;
        }
    }
    for (int n=0; n<arr.count; n++) {
        CGFloat tempP=[[arr[n] objectForKey:@"pointy"] floatValue];
        if (tempP>maxY) {
            maxY=tempP;
        }
    }
    
    //NSLog(@"Y最大差：%f",(maxY-minY));
//    if ((maxY-minY)<100) {
//        return 100;
//    }
    return (maxY-minY);
}
-(CGPoint)getPointFromArray:(NSArray *)arr
{
    CGFloat minX=0.0;
    CGFloat minY=0.0;
    if (arr.count>0) {
        NSDictionary *dic=arr[0];
        minX=[[dic objectForKey:@"pointx"] floatValue];
        minY=[[dic objectForKey:@"pointy"] floatValue];
    }
    for (int m=0; m<arr.count; m++) {
        NSDictionary *dic=arr[m];
        
        CGFloat pointx=[[dic objectForKey:@"pointx"] floatValue];
        CGFloat pointy=[[dic objectForKey:@"pointy"] floatValue];
        
        if (pointx<minX) {
            minX=pointx;
        }
        if (pointy<minY) {
            minY=pointy;
        }
    }
    return CGPointMake(minX, minY);
}

-(void)addPaths:(NSArray *)paths
{
    if (maxHeight>=self.frame.size.height-30-5-10) {
        return;
    }
//    NSLog(@"paths : %@",paths);
    if (paths.count>0) {
        [pathArray addObject:paths];
    }
    
    [myallline removeAllObjects];
}
-(void)endShow
{
    [drawCursor cancel]; //关闭光标线程
}
-(void)deleteLines
{
    int number=[[enterDic objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)pathArray.count]] intValue];
    if (number>0) {
        @synchronized (enterDic) {
            number=number-1;
            [enterDic setObject:[NSString stringWithFormat:@"%d",number] forKey:[NSString stringWithFormat:@"%lu",(unsigned long)pathArray.count]];
        }
    }else{
        if (pathArray.count>0) {
            [myallline addObject:[pathArray lastObject]];
            [pathArray removeLastObject];
        }
    }
}

-(void)deleteAllLines
{
    int number=[[enterDic objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)pathArray.count]] intValue];
    if (number>0) {
        @synchronized (enterDic) {
            number=number-1;
            [enterDic setObject:[NSString stringWithFormat:@"%d",number] forKey:[NSString stringWithFormat:@"%lu",(unsigned long)pathArray.count]];
        }
    }else{
        if (pathArray.count>0) {
            [myallline addObjectsFromArray:pathArray];
//            [myallline addObject:[pathArray lastObject]];
            [pathArray removeAllObjects];
        }
    }

}

//不能撤销删除的换行
-(void)cancelDeleteLines
{
    if (myallline.count>0) {
        [pathArray addObject:[myallline lastObject]];
        [myallline removeLastObject];
    }
}
//换行
-(void)enterLines
{
    if (maxHeight>=self.frame.size.height-30-5-10) {
        return;
    }
    
    @synchronized (enterDic) {
        int number=[[enterDic objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)pathArray.count]] intValue];
        number=number+1;
        [enterDic setObject:[NSString stringWithFormat:@"%d",number] forKey:[NSString stringWithFormat:@"%lu",(unsigned long)pathArray.count]];
    }
    [myallline removeAllObjects];
}
//空格
-(void)addSpace
{
    if (maxHeight>=self.frame.size.height-30-5-10) {
        return;
    }
    NSDictionary *dic1=[[NSDictionary alloc]initWithObjectsAndKeys:@"200",@"pointx",@"100.0",@"pointy",@"1",@"status",@"1",@"color", nil];
    NSDictionary *dic2=[[NSDictionary alloc]initWithObjectsAndKeys:@"220",@"pointx",@"150.0",@"pointy",@"2",@"status",@"1",@"color", nil];
    NSDictionary *dic3=[[NSDictionary alloc]initWithObjectsAndKeys:@"240",@"pointx",@"200.0",@"pointy",@"2",@"status",@"1",@"color", nil];
    NSDictionary *dic4=[[NSDictionary alloc]initWithObjectsAndKeys:@"260",@"pointx",@"250.0",@"pointy",@"2",@"status",@"1",@"color", nil];
    NSDictionary *dic5=[[NSDictionary alloc]initWithObjectsAndKeys:@"280",@"pointx",@"300.0",@"pointy",@"3",@"status",@"1",@"color", nil];
    NSArray *empty=[[NSArray alloc]initWithObjects:dic1,dic2,dic3,dic4,dic5, nil];
    [pathArray addObject:empty];
    [myallline removeAllObjects];
}

-(void)closeCursorViewAndThread
{
    [drawCursor cancel];
    CursorView.hidden=YES;
}

@end
