//
//  writeViewPaint.h
//  personalLetter
//
//  Created by gongweimeng on 16/8/31.
//  Copyright © 2016年 GWM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "drawViewPaint.h"

#import "UIColor-Expanded.h"
#import "KZColorPicker.h"

@class writeViewPaint;
@protocol writePaintDelegate <NSObject>

@optional
-(void)saveImage:(NSString *)imagePath view:(writeViewPaint *)hands;
-(void)deleteLines;
-(void)cancelDeleteLines;
-(void)setBackImage;

-(void)reloadDrawFrame;

-(void)setIsSubmimtCan;

-(void)changeImagePositionWithX:(CGFloat)xValue AndY:(CGFloat)yValue;
-(void)reSetInputImageRect;


@end
@interface writeViewPaint : UIView<drawPaintDelegate,KZColorPickerDelegate,UIGestureRecognizerDelegate>
{
    BOOL haveWritten;
}
@property(nonatomic,weak)id<writePaintDelegate> delegate;
@property(nonatomic,strong)drawViewPaint *paletteView;
@property(nonatomic,strong)UIImageView *backImage;
@property(nonatomic,strong)UIButton *colorWidthButton;
@property(nonatomic,strong)UIButton *doneBtn;
@property(nonatomic,strong)UIImageView *middleImageView;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIButton *forwardBtn;
@property(nonatomic,copy)NSString *imagePath;
@property(nonatomic,assign)int SegmentWidth;
@property(nonatomic,assign)int Segment;
@property(nonatomic,assign)CGPoint MyBeganpoint;
@property(nonatomic,assign)CGPoint MyMovepoint;

-(void)saveImageResult;




//0625
@property(nonatomic,strong)UIButton *spaceBtn;
@property(nonatomic,copy)NSMutableArray *resultLines;
@property(nonatomic,strong)NSMutableArray *linePathArray;

@property(nonatomic, retain) UIColor *selectedColor;


@property(nonatomic,assign)int red;
@property(nonatomic,assign)int green;
@property(nonatomic,assign)int blue;
@property(nonatomic,assign)CGFloat alp;
@property(nonatomic,retain)UIColor *colorResult;
@property(nonatomic,retain)UIColor *forwardColor;

@property(nonatomic,assign)BOOL isDelegateCan;

@property(nonatomic,assign)BOOL touchCan;
@property(nonatomic,assign)BOOL moveTouchCan;


//撤销
-(void)backBtn:(UIButton *)sender;

//橡皮擦
-(void)forwardBtn:(UIButton *)sender;

//重做
-(void)clearBtn:(UIButton *)sender;

//画笔
-(void)colorWidthButton:(UIButton *)sender;

//完成保存
-(void)doneButtonClicked:(int)tag;

@end
