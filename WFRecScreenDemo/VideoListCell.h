//
//  VideoListCell.h
//  YJDeskTop
//
//  Created by 王飞 on 16/12/30.
//  Copyright © 2016年 WF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoListCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView * iconImageView;
@property(nonatomic,strong)UILabel * nameLable;
@property(nonatomic,strong)UILabel * sizeLable;
@property(nonatomic,strong)UIButton * selectBtn;
@property(nonatomic,assign)BOOL isBeingSelected;

@property(nonatomic,copy)void(^callbackSelectedBtn)(NSInteger tag);

@property(nonatomic,copy)void(^callbackLongPress)(NSInteger tag);
@property(nonatomic,assign)NSInteger myCellTag;

@end
