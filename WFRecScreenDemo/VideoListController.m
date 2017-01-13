//
//  VideoListController.m
//  WFRecScreenDemo
//
//  Created by 王飞 on 17/1/13.
//  Copyright © 2017年 WF. All rights reserved.
//

#import "VideoListController.h"
#import "VideoInfo.h"
#import "VideoListCell.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "movieDetailController.h"

@interface VideoListController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView * _tableView;//视频的列表
    NSMutableArray * _dataArray;//视频列表的数据源
    NSInteger mytag;
}
@property(nonatomic,strong)NSMutableArray * data;


@end

@implementation VideoListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavi];
    [self initAllData];
    [self setUpTableView];

}

-(void)initAllData
{
    _dataArray = [[NSMutableArray alloc]init];
    self.data=[[NSMutableArray alloc]init];
    [self setDataArrayNameString];
    
    //    NSLog(@"_dataArray   %@",_dataArray);
}

-(void)setDataArrayNameString
{
    //大小
    NSMutableArray * sizeArray =[[NSMutableArray alloc]init];
    NSMutableArray * imageArray =[[NSMutableArray alloc]init];
    NSMutableArray * getAllMp4pathArray =[[NSMutableArray alloc]init];
    [getAllMp4pathArray addObjectsFromArray:[self getAllMp4path]];
    for (NSString * filePath in getAllMp4pathArray) {
        NSString * returnString = [[NSString alloc]init];
        returnString = [self fileSizeAtPath:filePath];
        if ([returnString isEqualToString:@"0"]||[returnString isEqualToString:@"0.00 KB"]) {
            [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
        }else
        {
            [sizeArray addObject:returnString];
            //图片
            UIImage * image =[[UIImage alloc]init];
            image =[self getScreenShotImageFromVideoPath:filePath];
            if (image) {
                [imageArray addObject:image];
            }else
            {
                UIImage * myimage=[UIImage imageNamed:@"default_video_poster"];
                [imageArray addObject:myimage];
            }
        }
    }
    
    //名字
    NSMutableArray * nameArray =[[NSMutableArray alloc]init];
    [nameArray addObjectsFromArray:[self getAllMp4Name]];
    
    NSString *finalPath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/myVideo"];
    
    for (int i=0 ; i<nameArray.count; i++) {
        VideoInfo * info =[[VideoInfo alloc]init];
        info.nameString = nameArray[i];
        //        NSLog(@"info.nameString   %@",info.nameString);
        NSString *outputPath = [finalPath stringByAppendingPathComponent:
                                [NSString stringWithFormat:@"%@",info.nameString]];
        info.pathString = outputPath;
        if (i<sizeArray.count) {
            info.sizeString = sizeArray[i];
        }
        if (i<imageArray.count) {
            info.image = imageArray[i];
        }
        [_dataArray addObject:info];
    }
    
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _tableView.contentInset = UIEdgeInsetsZero;
    _tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

-(void)setUpTableView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    // UICollectionViewFlowLayout流水布局的内部成员属性有以下：
    /**
     @property (nonatomic) CGFloat minimumLineSpacing;
     @property (nonatomic) CGFloat minimumInteritemSpacing;
     @property (nonatomic) CGSize itemSize;
     @property (nonatomic) CGSize estimatedItemSize NS_AVAILABLE_IOS(8_0); // defaults to CGSizeZero - setting a non-zero size enables cells that self-size via -preferredLayoutAttributesFittingAttributes:
     @property (nonatomic) UICollectionViewScrollDirection scrollDirection; // default is UICollectionViewScrollDirectionVertical
     @property (nonatomic) CGSize headerReferenceSize;
     @property (nonatomic) CGSize footerReferenceSize;
     @property (nonatomic) UIEdgeInsets sectionInset;
     */
    // 定义大小
    layout.itemSize = CGSizeMake((viewWidth-40)/2, 140);
    // 设置最小行间距
    layout.minimumLineSpacing = 20;
    // 设置垂直间距
    layout.minimumInteritemSpacing = 0;
    // 设置滚动方向（默认垂直滚动）
    //    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 设置边缘的间距，默认是{0，0，0，0}
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    
    _tableView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height+5,viewWidth,viewHeight-self.navigationController.navigationBar.frame.size.height-50-20) collectionViewLayout:layout];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor =[UIColor whiteColor];
    [_tableView registerClass:[VideoListCell class] forCellWithReuseIdentifier:@"cellid"];
    
    //    _tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.showsHorizontalScrollIndicator=NO;
    //    //设置数据较少的时候的白色底部
    //    [self setExtraCellLineHidden:_tableView];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
    if (!cell) {
        cell=[[VideoListCell alloc]init];
    }
    VideoInfo * info =[[VideoInfo alloc]init];
    info = _dataArray[indexPath.row];
    cell.selectBtn.tag = indexPath.row;

    cell.myCellTag=indexPath.row;
    cell.nameLable.text = info.nameString;
    cell.sizeLable.text = info.sizeString;
    cell.iconImageView.image = info.image;
    [cell setCallbackLongPress:^(NSInteger tag) {
        [self longPressCell:tag];
    }];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"------%zd", indexPath.item);
        VideoInfo * info = _dataArray[indexPath.row];
        if (info.pathString.length>0) {
            movieDetailController *nextVC=[[movieDetailController alloc]init];
            nextVC.videoPath=info.pathString;
//            NSLog(@"path  %@",info.pathString);
            nextVC.navigationItem.title=info.nameString;
            [self.navigationController pushViewController:nextVC animated:YES];
        }
}

-(void)setUpNavi
{
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    self.navigationController.navigationBar.barTintColor=MainColor;
    UIButton *leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [leftBtn addTarget:self action:@selector(backBtnClicked)forControlEvents:UIControlEventTouchUpInside ];
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    UIBarButtonItem *leftBarButon=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=leftBarButon;
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    self.navigationItem.title=@"视频列表";

}

-(void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  获取视频的缩略图方法 
 *
 *  @param filePath 视频的本地路径
 *
 *  @return 视频截图
 */
- (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath{
    
    UIImage *shotImage;
    //视频路径URL
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    shotImage = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return shotImage;
    
}

//单个文件的大小
- (NSString *) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* managerFile = [NSFileManager defaultManager];
    
    if ([managerFile fileExistsAtPath:filePath]){
        CGFloat oSize =[[managerFile attributesOfItemAtPath:filePath error:nil] fileSize]/1024.0;
        if (oSize<1024.0) {
            return [NSString stringWithFormat:@"%.2f KB",oSize];
        }else if (oSize<(1024.0*1024.0))
        {
            return [NSString stringWithFormat:@"%.2f M",oSize/1024];
        }else
        {
            return [NSString stringWithFormat:@"%.2f G",oSize/(1024*1024)];
        }
    }
    return @"0";
}

//获取/Documents/myVideo/目录下的所有mp4后缀的文件路径并返回数组
-(NSMutableArray *)getAllMp4Name
{
    NSString *fileWithstudentNumber = [NSHomeDirectory() stringByAppendingString:@"/Documents/myVideo"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *myDirectoryEnumerator = [fileManager enumeratorAtPath:fileWithstudentNumber];
    NSMutableArray *filePathArray = [[NSMutableArray alloc]init];   //用来存目录名字的数组
    NSString *file;
    while((file=[myDirectoryEnumerator nextObject]))     //遍历当前目录
    {
        if([[file pathExtension] isEqualToString:@"mp4"])  //取得后缀名为.mp4的文件名
        {
            [filePathArray addObject:file];//存到数组
        }
        
    }
    return filePathArray;
    
}

//获取/Documents/myVideo/目录下的所有mp4后缀的文件路径并返回数组
-(NSMutableArray *)getAllMp4path
{
    NSString *fileWithstudentNumber = [NSHomeDirectory() stringByAppendingString:@"/Documents/myVideo"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *myDirectoryEnumerator = [fileManager enumeratorAtPath:fileWithstudentNumber];
    NSMutableArray *filePathArray = [[NSMutableArray alloc]init];   //用来存目录名字的数组
    NSString *file;
    while((file=[myDirectoryEnumerator nextObject]))     //遍历当前目录
    {
        if([[file pathExtension] isEqualToString:@"mp4"])  //取得后缀名为.mp4的文件名
        {
            [filePathArray addObject:[fileWithstudentNumber stringByAppendingPathComponent:file]];//存到数组
        }
        
    }
    return filePathArray;
    
}


-(void)longPressCell:(NSInteger)tag
{
    mytag = tag;
    [self showLongPressAlert:tag];
    
}


-(void)showLongPressAlert:(NSInteger)tag
{
    UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否要删除视频" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self deleteLongPressCell:mytag];
    }
}


-(void)deleteLongPressCell:(NSInteger)tag
{
    VideoInfo * info = _dataArray[tag];
    if ([[NSFileManager defaultManager]fileExistsAtPath:info.pathString]) {
        [[NSFileManager defaultManager]removeItemAtPath:info.pathString error:nil];
    }
    [_dataArray removeObjectAtIndex:tag];
    //删除内容后reload data;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
