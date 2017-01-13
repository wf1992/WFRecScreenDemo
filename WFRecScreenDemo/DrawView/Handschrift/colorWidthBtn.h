//
//  colorWidthBtn.h
//  handschrift
//
//  Created by gongweimeng on 16/4/25.
//  Copyright © 2016年 YJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "centerBtn.h"
@interface colorWidthBtn : UIButton
@property(nonatomic,strong)UITabBarItem *item;
//中间圆形
@property(nonatomic,strong)centerBtn *centerButton;
@end
