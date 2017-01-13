//
//  PaletteEsayAnswer.h
//  headTeacherAssistant
//
//  Created by 王飞 on 16/9/7.
//  Copyright © 2016年 YJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PaletteEsayAnswer;
@protocol PaletteEsayAnswerDelegate <NSObject>

@optional
-(void)resetButtonViews:(BOOL)canForward canBack:(BOOL)canBack canClear:(BOOL)canClear;

@end


@interface PaletteEsayAnswer : UIView
{
    float x;
    float y;
    //-------------------------
    int             Intsegmentcolor;
    float           Intsegmentwidth;
    CGColorRef      segmentColor;
    //-------------------------
    NSMutableArray* myallpoint;
    //	NSMutableArray* myallline;//0625
    NSMutableArray* myallColor;
    NSMutableArray* myallwidth;
    
    NSMutableArray* myforwardline;
    NSMutableArray* myforwardcolor;
    NSMutableArray* myforwardwidth;
    NSMutableArray* myforwardpoint;
    
    BOOL canF;
}
@property(nonatomic,weak)id<PaletteEsayAnswerDelegate> delegate;
@property float x;
@property float y;
-(void)Introductionpoint1;
-(void)Introductionpoint2;
-(void)Introductionpoint3:(CGPoint)sender;
-(void)Introductionpoint4:(int)sender;
-(void)Introductionpoint5:(int)sender;
-(void)clearArray;
//=====================================
-(void)myalllineclear;
-(void)myLineFinallyRemove;
//-(void)myrubbereraser;


-(void)myForwardLineAdd;



//0625
@property(nonatomic,copy)NSMutableArray *myallline;

@end
