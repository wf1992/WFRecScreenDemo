//
//  showLinesView.h
//  YJEasyAnswer
//
//  Created by gongweimeng on 16/8/25.
//  Copyright © 2016年 YJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface showLinesView : UIView
-(id)initRects:(CGRect)rect lines:(NSMutableArray *)lines;
-(void)addPaths:(NSArray *)paths;
-(void)endShow;
-(void)deleteLines;
-(void)cancelDeleteLines;
-(void)enterLines;
-(void)addSpace;
-(void)deleteAllLines;


@property(nonatomic,copy)NSMutableArray *pathArray;
@property(nonatomic,copy)NSMutableDictionary *enterDic;
@property(nonatomic,assign)CGFloat maxHeight;
-(void)closeCursorViewAndThread;
@end
