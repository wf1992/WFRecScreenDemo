//
//  VideoInfo.h
//  YJDeskTop
//
//  Created by 王飞 on 16/12/30.
//  Copyright © 2016年 WF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoInfo : NSObject
@property(nonatomic,copy)NSString * nameString;
@property(nonatomic,copy)NSString * sizeString;
@property(nonatomic,strong)UIImage * image;
@property(nonatomic,copy)NSString * pathString;

@end
