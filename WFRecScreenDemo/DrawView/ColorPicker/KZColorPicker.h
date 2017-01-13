//
//  KZColorWheelView.h
//
//  Created by Alex Restrepo on 5/11/11.
//  Copyright 2011 KZLabs http://kzlabs.me
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYSliderPopover.h"
@class KZColorPickerHSWheel;
@class KZColorPickerBrightnessSlider;
@class KZColorPickerAlphaSlider;
@class KZColorPickerSwatchView;
@class KZColorPicker;
@protocol KZColorPickerDelegate <NSObject>

@optional
-(void)saveColor:(UIColor *)color width:(int)width;
@end
@interface KZColorPicker : UIControl
{
	KZColorPickerHSWheel *colorWheel;
	KZColorPickerBrightnessSlider *brightnessSlider;
    KZColorPickerAlphaSlider *alphaSlider;
    KZColorPickerSwatchView *currentColorIndicator;
	
    NSMutableArray *swatches;
    
	UIColor *selectedColor;
    BOOL displaySwatches;
}

@property (nonatomic, retain) UIColor *selectedColor;
@property (nonatomic, retain) UIColor *oldColor;
@property(nonatomic,strong)id<KZColorPickerDelegate> delegate;
@property(nonatomic,strong)NYSliderPopover *widthSlider;
@property(nonatomic,strong)UIButton *sureBtn;

- (void) setSelectedColor:(UIColor *)color animated:(BOOL)animated;
@end
