//
//  colorWidthBtn.m
//  handschrift
//
//  Created by gongweimeng on 16/4/25.
//  Copyright © 2016年 YJ. All rights reserved.
//

#import "colorWidthBtn.h"

@implementation colorWidthBtn


-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        // 添加中间圆形
        centerBtn *centerButton = [[centerBtn alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        centerButton.backgroundColor=[UIColor blackColor];
//        centerButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:centerButton];
        self.centerButton = centerButton;
    }
    return self;
}
// 重写去掉高亮状态
- (void)setHighlighted:(BOOL)highlighted {}

// 设置item
- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    
    // KVO 监听属性改变
    [item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}
- (void)dealloc
{
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
}
/**
 *  监听到某个对象的属性改变了,就会调用
 *
 *  @param keyPath 属性名
 *  @param object  哪个对象的属性被改变
 *  @param change  属性发生的改变
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    _centerButton.centerValue = _item.badgeValue.intValue;
//    NSLog(@"centerValue:%d",self.centerButton.centerValue);
    // 设置中心圆形的位置
    CGFloat badgeY = (self.frame.size.width - self.centerButton.frame.size.width)/2;
    //调整提醒的位置
    CGFloat badgeX = (self.frame.size.width - self.centerButton.frame.size.width)/2;
    CGRect badgeF = self.centerButton.frame;
    badgeF.origin.x = badgeX;
    badgeF.origin.y = badgeY;
    self.centerButton.frame = badgeF;
}
@end
