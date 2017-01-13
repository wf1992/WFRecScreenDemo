//
//  colorWidthView.h
//  handschrift
//
//  Created by gongweimeng on 16/4/26.
//  Copyright © 2016年 YJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "colorWidthBtn.h"
#import "NYSliderPopover.h"
@class colorWidthView;
@protocol CWviewDelegate <NSObject>
@optional
-(void)CWView:(colorWidthView *)CWview setCWvalue:(int)CWvalue;
@end
@interface colorWidthView : UIView
@property(nonatomic,assign)int CWvalue;
@property(nonatomic,assign)int colorValue;
@property(nonatomic,assign)int widthValue;
@property(nonatomic,strong)colorWidthBtn *btn0;
@property(nonatomic,strong)colorWidthBtn *btn1;
@property(nonatomic,strong)colorWidthBtn *btn2;
@property(nonatomic,strong)colorWidthBtn *btn3;
@property(nonatomic,strong)UITabBarItem *item0;
@property(nonatomic,strong)UITabBarItem *item1;
@property(nonatomic,strong)UITabBarItem *item2;
@property(nonatomic,strong)UITabBarItem *item3;
@property(nonatomic,weak)id<CWviewDelegate> delegate;
@property(nonatomic,strong)NYSliderPopover *widthSlider;
@property(nonatomic,strong)UIImageView *sliderImage;
@end
