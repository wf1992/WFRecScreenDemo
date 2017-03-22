//
//  CanvasView.h
//  lexueCanvas
//
//  Created by 白冰 on 13-5-14.
//  Copyright (c) 2013年 白冰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACEDrawingView.h"

@protocol BlazeiceDooleViewDelegate <NSObject>

-(void)getPenColorResult:(UIColor *)color;

@end

typedef enum {
    BlazeiceDrawToolTypePen,
    BlazeiceDrawToolTypeMedia,
    BlazeiceDrawToolTypeLine,
    BlazeiceDrawToolTypeRectagleStroke,
    BlazeiceDrawToolTypeRectagleFill,
    BlazeiceDrawToolTypeEllipseStroke,
    BlazeiceDrawToolTypeEllipseFill,
} BlazeiceDrawToolType;

@interface BlazeiceDooleView : UIImageView
@property(nonatomic,strong) UIView *saveImageView;
@property(nonatomic,strong) ACEDrawingView *drawView;
@property(nonatomic,strong) id<BlazeiceDooleViewDelegate>delegate;
//设置最先相应
-(void)setNowFirstResponder;
-(void)resizableViewPinch:(BOOL)isEnale;
- (void)showImageView:(UIImage *)image;
-(void)cancelLastSaveImage;

//画笔
-(void)penToChooseColor;

//橡皮擦
-(void)esarBtnToChangeClear;

//撤销
-(void)cancleBtnToBackForward;

//清除
-(void)clearBtnToRemoveAll;

@property(nonatomic,retain)UIColor *colorResult;


@end
