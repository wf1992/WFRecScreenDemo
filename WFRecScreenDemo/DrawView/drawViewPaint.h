//
//  drawViewPaint.h
//  personalLetter
//
//  Created by gongweimeng on 16/8/31.
//  Copyright © 2016年 GWM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class drawViewPaint;
@protocol drawPaintDelegate <NSObject>

@optional
-(void)resetButtonViews:(BOOL)canForward canBack:(BOOL)canBack canClear:(BOOL)canClear;

@end
@interface drawViewPaint : UIView
{
    float x;
    float y;
    //-------------------------
    int             Intsegmentcolor;
    float           Intsegmentwidth;
    CGColorRef      segmentColor;
    UIColor      *selectedColor;
    //-------------------------
//    NSMutableArray* myallpoint;
//    //	NSMutableArray* myallline;//0625
//    NSMutableArray* myallColor;
//    NSMutableArray* myallwidth;
    
    NSMutableArray* myforwardline;
    NSMutableArray* myforwardcolor;
    NSMutableArray* myforwardwidth;
    NSMutableArray* myforwardpoint;
    
    BOOL canF;
    NSMutableArray *myAllScale;
}
@property(nonatomic,weak)id<drawPaintDelegate> delegate;
@property(nonatomic,copy)NSMutableArray* myallColor;
@property(nonatomic,copy)NSMutableArray* myallwidth;
@property(nonatomic,copy)NSMutableArray* myallpoint;
@property(nonatomic,copy)NSMutableArray* myallBezierPath;

@property float x;
@property float y;
-(void)Introductionpoint1;
-(void)Introductionpoint2:(UIColor *)sender;;
-(void)Introductionpoint3:(CGPoint)sender;
-(void)Introductionpoint4:(CGFloat)sender;
-(void)Introductionpoint5:(int)sender;
-(void)Introductionpoint6:(UIBezierPath*)sender;

-(void)clearArray;
//=====================================
-(void)myalllineclear;
-(void)myLineFinallyRemove;
//-(void)myrubbereraser;


-(void)myForwardLineAdd;

-(void)setSelectColor:(UIColor *)sender;

//0625
@property(nonatomic,copy)NSMutableArray *myallline;


-(void)resetColorsArray;
@end
