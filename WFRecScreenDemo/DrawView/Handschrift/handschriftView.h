//
//  handschriftView.h
//  handschrift
//
//  Created by gongweimeng on 16/4/25.
//  Copyright © 2016年 YJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Palette.h"
#import "colorWidthView.h"
@class handschriftView;
@protocol handschriftDelegate <NSObject>

@optional
-(void)saveImage:(NSString *)imagePath view:(handschriftView *)hands;

@end
@interface handschriftView : UIView<CWviewDelegate,PaletteDelegate>
{
    colorWidthView *CWview;
    
}
@property(nonatomic,weak)id<handschriftDelegate> delegate;
@property(nonatomic,strong)Palette *paletteView;
@property(nonatomic,strong)colorWidthBtn *colorWidthButton;
@property(nonatomic,strong)UIButton *doneBtn;
@property(nonatomic,strong)UIImageView *middleImageView;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIButton *forwardBtn;
@property(nonatomic,copy)NSString *imagePath;
@property(nonatomic,assign)int SegmentWidth;
@property(nonatomic,assign)int Segment;
@property(nonatomic,assign)CGPoint MyBeganpoint;
@property(nonatomic,assign)CGPoint MyMovepoint;
@property(nonatomic,strong)UITabBarItem *item;
@property(nonatomic,assign)BOOL haveWritten;
-(void)saveImageResult;
@end
