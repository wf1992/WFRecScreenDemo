//
//  handschriftViewEsayAnswer.h
//  headTeacherAssistant
//
//  Created by 王飞 on 16/9/7.
//  Copyright © 2016年 YJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaletteEsayAnswer.h"
#import "colorWidthView.h"
@class handschriftViewEsayAnswer;
@protocol handschriftEsayAnswerDelegate <NSObject>

@optional
-(void)saveImage:(NSString *)imagePath view:(handschriftViewEsayAnswer *)hands;
-(void)deleteLines;
-(void)cancelDeleteLines;
-(void)enterLines;
-(void)spaceText;
-(void)setstatusToInput;
-(void)deleteAllLines;

@end

@interface handschriftViewEsayAnswer : UIView<CWviewDelegate,PaletteEsayAnswerDelegate>
{
    colorWidthView *CWview;
    BOOL haveWritten;
}
@property(nonatomic,weak)id<handschriftEsayAnswerDelegate> delegate;
@property(nonatomic,strong)PaletteEsayAnswer *paletteView;
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

-(void)saveImageResult;

-(void)forwardBtn:(UIButton *)sender;
-(void)backBtn:(UIButton *)sender;



//0625
@property(nonatomic,strong)UIButton *spaceBtn;
@property(nonatomic,copy)NSMutableArray *resultLines;
@property(nonatomic,strong)NSMutableArray *linePathArray;

@end
