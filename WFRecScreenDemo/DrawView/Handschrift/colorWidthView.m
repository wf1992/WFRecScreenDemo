//
//  colorWidthView.m
//  handschrift
//
//  Created by gongweimeng on 16/4/26.
//  Copyright © 2016年 YJ. All rights reserved.
//

#import "colorWidthView.h"

@implementation colorWidthView

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}
-(void)setUpViews
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *temp=[userDefaults objectForKey:@"centerValueString"];
    self.colorValue=temp.intValue/100;
    self.widthValue=temp.intValue%100;
    
    self.backgroundColor=[UIColor whiteColor];
    
    UITabBarItem *item0=[[UITabBarItem alloc]init];
    item0.badgeValue=[NSString stringWithFormat:@"%d",200+self.widthValue];
    self.item0=item0;
    UITabBarItem *item1=[[UITabBarItem alloc]init];
    item1.badgeValue=[NSString stringWithFormat:@"%d",300+self.widthValue];
    self.item1=item1;
    UITabBarItem *item2=[[UITabBarItem alloc]init];
    item2.badgeValue=[NSString stringWithFormat:@"%d",400+self.widthValue];
    self.item2=item2;
    UITabBarItem *item3=[[UITabBarItem alloc]init];
    item3.badgeValue=[NSString stringWithFormat:@"%d",600+self.widthValue];
    self.item3=item3;
    
    colorWidthBtn *btn0=[[colorWidthBtn alloc]initWithFrame:CGRectMake(10, self.frame.size.height-(10+60), 60, 60)];
    btn0.backgroundColor=[UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
    CALayer *layer0=[btn0 layer];
    layer0.cornerRadius=30;
    layer0.masksToBounds=YES;
    [btn0 addTarget:self action:@selector(btn0:) forControlEvents:UIControlEventTouchUpInside];
    btn0.item=self.item0;
    [self addSubview:btn0];
    self.btn0=btn0;
    colorWidthBtn *btn1=[[colorWidthBtn alloc]initWithFrame:CGRectMake(10, self.frame.size.height-(10+60)*2, 60, 60)];
    btn1.backgroundColor=[UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
    CALayer *layer1=[btn1 layer];
    layer1.cornerRadius=30;
    layer1.masksToBounds=YES;
    [btn1 addTarget:self action:@selector(btn1:) forControlEvents:UIControlEventTouchUpInside];
    btn1.item=self.item1;
    [self addSubview:btn1];
    self.btn1=btn1;
    colorWidthBtn *btn2=[[colorWidthBtn alloc]initWithFrame:CGRectMake(10, self.frame.size.height-(10+60)*3, 60, 60)];
    btn2.backgroundColor=[UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
    CALayer *layer2=[btn2 layer];
    layer2.cornerRadius=30;
    layer2.masksToBounds=YES;
    [btn2 addTarget:self action:@selector(btn2:) forControlEvents:UIControlEventTouchUpInside];
    btn2.item=self.item2;
    [self addSubview:btn2];
    self.btn2=btn2;
    colorWidthBtn *btn3=[[colorWidthBtn alloc]initWithFrame:CGRectMake(10, self.frame.size.height-(10+60)*4, 60, 60)];
    btn3.backgroundColor=[UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.0];
    CALayer *layer3=[btn3 layer];
    layer3.cornerRadius=30;
    layer3.masksToBounds=YES;
    [btn3 addTarget:self action:@selector(btn3:) forControlEvents:UIControlEventTouchUpInside];
    btn3.item=self.item3;
    [self addSubview:btn3];
    self.btn3=btn3;
    
    UIImageView *sliderImage=[[UIImageView alloc]initWithFrame:CGRectMake(80, self.frame.size.height-(10+60)+10, self.frame.size.width-80-10, 40)];
    sliderImage.userInteractionEnabled=YES;
    CALayer *layerImage=[sliderImage layer];
    layerImage.cornerRadius=20;
    layerImage.masksToBounds=YES;
    layerImage.borderWidth=1.0;
    layerImage.borderColor=[[UIColor lightGrayColor]CGColor];
    NYSliderPopover *widthSlider=[[NYSliderPopover alloc]initWithFrame:CGRectMake(100, self.frame.size.height-90, self.frame.size.width-100-30, 100)];
    [widthSlider addTarget:self action:@selector(widthSlider:) forControlEvents:UIControlEventValueChanged];
    widthSlider.minimumValue=1;
    widthSlider.maximumValue=10;
    widthSlider.minimumTrackTintColor=[UIColor lightGrayColor];
    widthSlider.maximumTrackTintColor=[UIColor lightGrayColor];
    //    NSLog(@"%d _____ %d",self.colorValue,self.widthValue);
    switch (self.colorValue) {
        case 6:
            [widthSlider setThumbTintColor:[UIColor blackColor]];
            break;
        case 2:
            [widthSlider setThumbTintColor:[UIColor colorWithRed:28/255.0 green:198/255.0 blue:8/255.0 alpha:1.0]];
            break;
        case 3:
            [widthSlider setThumbTintColor:[UIColor colorWithRed:11/255.0 green:56/255.0 blue:150/255.0 alpha:1.0]];
            break;
        case 4:
            [widthSlider setThumbTintColor:[UIColor colorWithRed:249/255.0 green:0/255.0 blue:9/255.0 alpha:1.0]];
            break;
        default:
            break;
    }
    widthSlider.value=self.widthValue;
    self.sliderImage=sliderImage;
    self.widthSlider=widthSlider;
    [self addSubview:self.sliderImage];
    [self addSubview:self.widthSlider];
    [self updateSliderPopoverText];
}
-(void)widthSlider:(UISlider *)sender
{
    [self updateSliderPopoverText];
    _widthValue=(int)sender.value;
    _item0.badgeValue=[NSString stringWithFormat:@"%d",200+_widthValue];
    _item1.badgeValue=[NSString stringWithFormat:@"%d",300+_widthValue];
    _item2.badgeValue=[NSString stringWithFormat:@"%d",400+_widthValue];
    _item3.badgeValue=[NSString stringWithFormat:@"%d",600+_widthValue];
}
- (void)updateSliderPopoverText
{
    _widthSlider.popover.textLabel.text = [NSString stringWithFormat:@"%d", (int)_widthSlider.value];;
}
-(void)btn0:(UIButton *)sender
{
    _colorValue=2;
    [self.widthSlider setThumbTintColor:[UIColor colorWithRed:28/255.0 green:198/255.0 blue:8/255.0 alpha:1.0]];
    [self callDelegate];
}
-(void)btn1:(UIButton *)sender
{
    _colorValue=3;
    [self.widthSlider setThumbTintColor:[UIColor colorWithRed:11/255.0 green:56/255.0 blue:150/255.0 alpha:1.0]];
    [self callDelegate];
}
-(void)btn2:(UIButton *)sender
{
    _colorValue=4;
    [self.widthSlider setThumbTintColor:[UIColor colorWithRed:249/255.0 green:0/255.0 blue:9/255.0 alpha:1.0]];
    [self callDelegate];
}
-(void)btn3:(UIButton *)sender
{
    _colorValue=6;
    [self.widthSlider setThumbTintColor:[UIColor blackColor]];
    [self callDelegate];
}
-(void)callDelegate
{
    _CWvalue=_colorValue*100+_widthValue;
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%d",_CWvalue] forKey:@"centerValueString"];
    [userDefaults synchronize];
    //通知代理
    if ([self.delegate respondsToSelector:@selector(CWView:setCWvalue:)]) {
        [self.delegate CWView:self setCWvalue:_CWvalue];
    }
    [self removeFromSuperview];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{}
@end
