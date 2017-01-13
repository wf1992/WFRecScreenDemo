
//
//  centerBtn.m
//  handschrift
//
//  Created by gongweimeng on 16/4/25.
//  Copyright © 2016年 YJ. All rights reserved.
//

#import "centerBtn.h"

@implementation centerBtn


-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.hidden=NO;
        self.userInteractionEnabled=NO;
        self.backgroundColor=[UIColor redColor];
    }
    return self;
}
-(void)setCenterValue:(int)centerValue
{
    _centerValue=centerValue;
    if (centerValue>0) {
        self.hidden=NO;
        CGRect frame = self.frame;
        CGFloat badgeW = 10;
        badgeW = (_centerValue%100)*6;
        frame.size.width = badgeW;
        frame.size.height = badgeW;
        self.frame = frame;
        CALayer *layer=[self layer];
        layer.cornerRadius=self.frame.size.width/2;
        layer.masksToBounds=YES;
        
        int color=_centerValue/100;
//        NSLog(@"color:%d",color);
        switch (color) {
            case 0:
                self.backgroundColor=[UIColor colorWithRed:250/255.0 green:134/255.0 blue:11/255.0 alpha:1.0];
                break;
            case 1:
                self.backgroundColor=[UIColor colorWithRed:255/255.0 green:255/255.0 blue:13/255.0 alpha:1.0];
                break;
            case 2:
                self.backgroundColor=[UIColor colorWithRed:28/255.0 green:198/255.0 blue:8/255.0 alpha:1.0];
                break;
            case 3:
                self.backgroundColor=[UIColor colorWithRed:11/255.0 green:56/255.0 blue:150/255.0 alpha:1.0];
                break;
            case 4:
                self.backgroundColor=[UIColor colorWithRed:249/255.0 green:0/255.0 blue:9/255.0 alpha:1.0];
                break;
            case 5:
                self.backgroundColor=[UIColor colorWithRed:38/255.0 green:36/255.0 blue:84/255.0 alpha:1.0];
                break;
            case 6:
                self.backgroundColor=[UIColor blackColor];
                break;
            default:
                self.backgroundColor=[UIColor blackColor];
                break;
        }
    }else{
        self.backgroundColor=[UIColor blackColor];
        self.hidden=YES;
    }
}
@end
