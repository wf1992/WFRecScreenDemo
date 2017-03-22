//
//  CanvasView.m
//  lexueCanvas
//
//  Created by 白冰 on 13-5-14.
//  Copyright (c) 2013年 白冰. All rights reserved.
//

#import "BlazeiceDooleView.h"
#import "ACEDrawingView.h"
#import "UIColor+Extend.h"
#import "AppDelegate.h"
#define colorCount 4

@implementation BlazeiceDooleView
{
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

}

@synthesize saveImageView;
@synthesize drawView;

#pragma mark -
#pragma mark Scribble observer method
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.userInteractionEnabled = YES;
        
        /*NSString* colorStr=[WHITECOLORARR objectAtIndex:0];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"defaultsColor"]) {
            colorStr=[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultsColor"];
        }
        if ([colorStr length]<4) {
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",colorStr]]];
        }
        else{
            self.backgroundColor = [UIColor colorWithHexString:colorStr];
        }*/
//        NSString* colorStr=@"475e45";
//        self.backgroundColor = [UIColor colorWithHexString:colorStr];
        self.backgroundColor = [UIColor clearColor];
        //初始化 悬浮图片view
        saveImageView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        saveImageView.backgroundColor=[UIColor clearColor];
        [self addSubview:saveImageView];
        //初始化 scribble_涂鸦 模型
        drawView = [[ACEDrawingView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        drawView.drawTool = ACEDrawingToolTypePen;
        drawView.isclear = NO;
        drawView.lineAlpha = 1.0;
        drawView.lineWidth = 3.0;
        drawView.lineColor = _colorResult;
        [self addSubview:drawView];
        
        colorArr = [[NSMutableArray alloc]init];
        [colorArr addObject:[UIColor blackColor]];
        [colorArr addObject:[UIColor blueColor]];
        [colorArr addObject:[UIColor redColor]];
        [colorArr addObject:[UIColor yellowColor]];

    }
    return self;
}

//此方法是为了重新加载drawView
-(void)layoutSubviews
{
    [drawView updateCacheImage:YES];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
}

#pragma mark - function

//画笔
-(void)penToChooseColor
{

    _isAddViewShowing =!_isAddViewShowing;
    if (_isAddViewShowing) {
        [self createAddView];
        
    }else
    {
        [self dismiss];
    }

}

//橡皮擦
-(void)esarBtnToChangeClear
{
    drawView.lineColor = [UIColor whiteColor];
    drawView.lineWidth = 10.0;
}

//撤销
-(void)cancleBtnToBackForward
{
    [drawView cancelLastPath];
}

//清除
-(void)clearBtnToRemoveAll
{
    [drawView clear];
}




//设置最先相应
-(void)setNowFirstResponder
{
    [self becomeFirstResponder];
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyImage:)];
    UIMenuItem *cancelItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(cancelBoardImage:)];
    [UIMenuController sharedMenuController].menuItems = @[copyItem,cancelItem,];
}

//删除涂鸦图片
-(void)cancelLastSaveImage
{
    if ([saveImageView.subviews count]) {
        [[saveImageView.subviews lastObject] removeFromSuperview];
    }
}

//显示复制按钮
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copyImage:)){
        return YES;
    }
    else if(action == @selector(cancelBoardImage:)){
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}


//删除涂鸦图片
-(void)cancelBoardImage:(id)sender
{
    [self cancelLastSaveImage];
}
#pragma mark - SPUserResizableViewDeleagetEed
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

- (void)SinglePan:(UIPanGestureRecognizer*)recognizer
{
    UIView *panView = [recognizer view];
    [self adjustAnchorPointForGestureRecognizer:recognizer];
    if ([recognizer state] == UIGestureRecognizerStateBegan || [recognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:[panView superview]];
        
        [panView setCenter:CGPointMake([panView center].x + translation.x, [panView center].y + translation.y)];
        [recognizer setTranslation:CGPointZero inView:[panView superview]];
    }
}

#pragma mark - UIPanGestureRecognizer delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (void)dealloc
{
}



-(void)createAddView
{
    // 背景
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(KWidth/2-150, 100, 170, 50)];
    _maskView.backgroundColor = [UIColor clearColor];
    [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    [self.superview addSubview:_maskView];
    _triangleFrame = CGRectMake(_width - 25, 0, 18, 14);
    _width  =176;
    
    // 三角形
    [self applytriangleView];
    
    // item
    for (int i =0; i<colorCount; i++) {
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame =CGRectMake(10+40*(i%colorCount), 10, 30, 30);
        [btn setBackgroundColor:colorArr[i]];
        [btn addTarget:self action:@selector(colorBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag =i ;
        [_maskView addSubview:btn];
    }
    
    //    _maskView.center = CGPointMake(25, KWidth/2+110);
}

-(void)colorBtnClicked:(UIButton *)sender
{
    UIButton * btn =(UIButton *)sender;
    NSInteger tag = btn.tag;
    _colorResult = colorArr[tag];
    [self closeAddView];
    _isAddViewShowing =NO;
    drawView.lineColor = _colorResult;
    drawView.lineWidth = 3.0;
    
    if ([self.delegate respondsToSelector:@selector(getPenColorResult:)]) {
        [self.delegate getPenColorResult:_colorResult];
    }
    
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
    if (_triangleView == nil) {
        _triangleView = [[UIView alloc] init];
        _triangleView.backgroundColor = [UIColor whiteColor];
        [self.superview addSubview:_triangleView];
    }
    _triangleFrame = CGRectMake( KWidth/2-120, 95, CGRectGetWidth(_triangleFrame), CGRectGetHeight(_triangleFrame));
    _triangleView.frame = _triangleFrame;
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, &CGAffineTransformIdentity, CGRectGetWidth(_triangleFrame) / 2.0, 0);
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, 0, CGRectGetHeight(_triangleFrame));
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, CGRectGetWidth(_triangleFrame), CGRectGetHeight(_triangleFrame));
    shaperLayer.path = path;
    _triangleView.layer.mask = shaperLayer;
}










@end
