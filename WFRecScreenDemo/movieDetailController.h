//
//  movieDetailController.h
//  YJGuidanceLearning
//
//  Created by gongweimeng on 16/8/1.
//  Copyright © 2016年 YJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@protocol GWMMoviePlayerViewControllerDelegate <NSObject>

- (void)moviePlayerDidFinished;
- (void)moviePlayerDidCapturedWithImage:(UIImage *)image;

@end
@interface movieDetailController : ViewController
@property (nonatomic, weak) id<GWMMoviePlayerViewControllerDelegate> delegate;
@property (nonatomic, strong) NSURL *movieURL;

@property(nonatomic,copy)NSString *videoPath;
@end
