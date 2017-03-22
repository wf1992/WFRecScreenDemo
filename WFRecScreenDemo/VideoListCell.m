//
//  VideoListCell.m
//  YJDeskTop
//
//  Created by 王飞 on 16/12/30.
//  Copyright © 2016年 WF. All rights reserved.
//

#import "VideoListCell.h"

@implementation VideoListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isBeingSelected=NO;
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI
{
    //长按删除手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGuesture:)];
    [self.contentView addGestureRecognizer:longPress];
    
    _selectBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame =CGRectMake(contentViewWidth -30, 0, 30, 30);
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
    [_selectBtn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectBtn];
    _selectBtn.hidden=YES;
    
    _iconImageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 35, contentViewWidth -20, 80)];
    [self.contentView addSubview:_iconImageView];
    
    _nameLable =[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_iconImageView.frame)+5, 115, 21)];
    _nameLable.font =[UIFont systemFontOfSize:13];
    _nameLable.textColor =[UIColor blackColor];
    [self.contentView addSubview:_nameLable];

    _sizeLable=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_nameLable.frame), CGRectGetMaxY(_iconImageView.frame)+5, 70, 21)];
    _sizeLable.font =[UIFont systemFontOfSize:13];
    _sizeLable.textColor =[UIColor blackColor];
    [self.contentView addSubview:_sizeLable];

}

-(void)selectBtnClicked:(UIButton * )sender
{
//    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    _isBeingSelected = !_isBeingSelected;
    if (_isBeingSelected) {
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }else
    {
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
    }
    UIButton * btn = (UIButton *)sender;
    _callbackSelectedBtn(btn.tag);
}

-(void)prepareForReuse
{
    _nameLable.text =@"";
    _sizeLable.text =@"";
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
    _isBeingSelected=NO;

}


- (void)handleLongPressGuesture:(UILongPressGestureRecognizer *)guesture {
    CGPoint startPoint;
    
    switch (guesture.state) {
            //手势开始
        case UIGestureRecognizerStateBegan:
        {
            NSLog(@"longpress started");
            _callbackLongPress(_myCellTag);

//            //获得截图
//            snapView = [_containerView snapshotViewAfterScreenUpdates:NO];
//            //叶神原文中重设了锚点，我没有
//            //            snapView.layer.anchorPoint = CGPointMake(startPoint.x/snapView.layer.frame.size.width-0.1, startPoint.y/snapView.layer.frame.size.height-0.1);
//            snapView.frame = _containerView.frame;
//            snapView.transform = CGAffineTransformMakeRotation(M_PI/6);
//            startPoint = [guesture locationInView:self.contentView];
//            
//            [self.contentView addSubview:snapView];
//            //隐藏原有view
//            _shadowView.hidden = YES;
//            _containerView.hidden = YES;
            
            
            break;
        }
            //手势移动
        case UIGestureRecognizerStateChanged: {
            NSLog(@"longpress changed");
//            CGPoint changedPoint = [guesture locationInView:self.contentView];
//            //一开始把snapView设为了局部变量，这个动画不管用，将snapView改为全局变量就可以了。为啥嗯？
//            [UIView animateWithDuration:0.5 animations:^{
//                snapView.layer.position = changedPoint;
//            }];
            break;
        }
            //手势结束
        case UIGestureRecognizerStateEnded: {
            NSLog(@"longpress ended");
            
//
//            CGPoint endedPoint = [guesture locationInView:self.contentView];
//            //设定删除边界，超过则删除
//            if (endedPoint.x > self.contentView.bounds.size.width - 50 ) {
//                if (_cellBlock) {
//                    _cellBlock(YES, _cellIndex);
//                    
//                }
//            }
//            else {
//                if (_cellBlock) {
//                    _cellBlock(NO, _cellIndex);
//                    
//                }
//            }
//            //手势结束后收拾cell view，原先隐藏的view再显示，snapview移除，此处无论是否删除cell，都会移除snapview并显示原先的view。
//            [snapView removeFromSuperview];
//            _containerView.hidden = NO;
//            _shadowView.hidden = NO;
        }
        default:
            break;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
