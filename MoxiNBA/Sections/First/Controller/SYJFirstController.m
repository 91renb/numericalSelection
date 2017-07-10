//
//  SYJFirstController.m
//  MoxiNBA
//
//  Created by 尚勇杰 on 2017/6/26.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "SYJFirstController.h"
#import <SDCycleScrollView.h>
#import "DataConfigManager.h"
#import "SYJHallCell.h"
#import "Header.h"
#import "RequestModel.h"
#import "FootballLotteryManagers.h"
#import "PJNavigationBar.h"
#import "DataConfigManager.h"
#import "PJCollectionViewCell.h"
#import "BetCartViewController.h"

#import "CTFBBettingViewController.h"
#define ItemHeight 50

#import "TZBaseViewController.h"



@interface SYJFirstController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
    NSArray *_data;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *listArr;

@property (nonatomic, strong) SDCycleScrollView *cycleView;

@end

@implementation SYJFirstController

- (NSMutableArray  *)listArr{
    
    if (_listArr == nil) {
        _listArr = [NSMutableArray array];
    }
    
    return _listArr;
}


- (UIView *)cycleView
{
    if (!_cycleView)
    {
        SYJFirstController __weak *safeSelf = self;
        _cycleView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(5, -145, KSceenW - 10, 140)];
        _cycleView.placeholderImage = [UIImage imageNamed:@"图标"];
        _cycleView.currentPageDotColor = [UIColor whiteColor];
        _cycleView.layer.masksToBounds = YES;
        _cycleView.layer.borderColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0].CGColor;
        _cycleView.layer.borderWidth = 1.0;
        _cycleView.layer.cornerRadius = 5;
        
    }
    return _cycleView;
}


- (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = KSceenW / 2 ;
    segmentBarLayout.itemSize = CGSizeMake(width,ScaleH(50));
    segmentBarLayout.minimumLineSpacing = 0;
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationItem setNewTitle:@"开奖大厅"];

}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    _data = [DataConfigManager getMainConfigList];

    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:[self segmentBarLayout]];
    [self.view addSubview:self.collectionView];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[SYJHallCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    _collectionView.alwaysBounceVertical  = YES;
    [_collectionView addSubview:self.cycleView];

    self.collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.contentInset = UIEdgeInsetsMake(150, 0, 0, 0);

    
    [self getDatas];

//    [SVProgressHUD showWithStatus:@"loading..."];
    //添加刷新
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self getHttpResqust];
//    }];
    
    
    //自动更改透明度
//    self.tableView.mj_header.automaticallyChangeAlpha = YES;
//    [self.tableView.mj_header beginRefreshing];

    
    // Do any additional setup after loading the view.
}

- (void)getDatas
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setPublicDomain:kAPI_banner];
    _connection = [RequestModel POST:URL(kAPI_banner) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   {
                       NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"]stringByAppendingPathComponent:@"banner.archiver"] ;
                       [NSKeyedArchiver archiveRootObject:data[@"item"] toFile:filePath];
                    
                       NSMutableArray *arr = [NSMutableArray array];
                       NSArray *list = data[@"item"];
                       for (int i = 0;i < list.count; i ++)
                       {
                           NSDictionary *dic = list[i];
                           
                           NSString *url = [NSString stringWithFormat:@"%@/%@",serverUrl,dic[@"img_url"]];
                           [arr addObject:url];
                           
                       }
                       
                       self.cycleView.imageURLStringsGroup = arr;
                       SYJLog(@"%@",arr);
                       
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       [SVProgressHUD showInfoWithStatus:msg];
                   }];

   
    
}


#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, ScaleH(50)); // header
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    headerView.backgroundColor = NavColor;
    UILabel *titleHeader = (UILabel *)[headerView viewWithTag:100];
    if (!titleHeader)
    {
        titleHeader = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultInset.left, 0, 200, ScaleH(50))];;
        titleHeader.tag = 100;
        titleHeader.font = Font(16);
        titleHeader.textColor = [UIColor purpleColor];
        [headerView addSubview:titleHeader];
    }
    titleHeader.text = _data[indexPath.section][@"headerTitle"];
    return headerView;
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _data.count ;
}


//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_data[section ][@"row"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SYJHallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.datallist = _data[indexPath.section ][@"row"][indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 0)
    {
        [self gotoFootballcompetition:indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        [self gotoCTZQ:indexPath];
    }
    else if(indexPath.section == 2)
    {
        switch (indexPath.row)
        {
            case 0:  //大乐透
            {
                [self gotoLeTouNumber:lDLT_lottery];
            }
                break;
            case 1: //双色球
            {
                /*判断一下，如果hide_pk有值，就隐藏双色球*/
                //                NSString *str = @"11";
                //                if(str.length>0)
                //                {
                //                   [SVProgressHUD showInfoWithStatus:@"即将开放，敬请期待~"];
                //                }
                //                else
                //                {
                [self gotoLeTouNumber:lSSQ_lottery];
                //                }
                
            }
                break;
            case 2: //七星彩
            {
                [self gotoLeTouNumber:lSenvenStar_lottery];
            }
                break;
            case 3: //排列3
            {
                [self gotoLeTouNumber:lPL3_lottery];
            }
                break;
            case 4:  //排列5
            {
                [self gotoLeTouNumber:lPL5_lottery];
            }
                break;
                
            default:
                break;
        }
        
        
    }
    else if(indexPath.section == 3)
    {
        switch (indexPath.row)
        {
            case 0:  //22选5
            {
                [self gotoLeTouNumber:lT225_lottery];
            }
                break;
            case 1: //32选7
            {
                [self gotoLeTouNumber:lT317_lottery];
            }
                break;
            case 2: //36选7
            {
                [self gotoLeTouNumber:lT367_lottery];
            }
                break;
                
            default:
                break;
        }
        
    }
}


#pragma mark - 竞彩足球
- (void)gotoFootballcompetition:(FBPlayType)lotterytype
{
    FootballLotteryManagers *manager = [[FootballLotteryManagers alloc] initWithPlayType:lotterytype];
    manager.hidesBottomBarWhenPushed = YES;
    [self pushViewController:manager];
}

#pragma mark 传统足球
- (void)gotoCTZQ:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _data[indexPath.section][@"row"][indexPath.row];
    Class class = NSClassFromString(dic[@"viewController"]);
    UIViewController *controller = [class new];
    [self addNavigationWithPresentViewController:controller];
}

#pragma mark - 乐透数字
- (void)gotoLeTouNumber:(NSInteger)lotteryType
{
    // 初始化购物车视图控制器
    NSString *vcStr = getLotVCString(lotteryType);
    Class class =  NSClassFromString(vcStr);
    TZBaseViewController *mController = [(TZBaseViewController*)[class alloc] initWithLotter_pk:GET_INT(lotteryType) period:nil requestCode:YES delegate:nil];
    
    PJNavigationController *nav = [[PJNavigationController alloc]initWithRootViewController:mController];
    [self presentViewController:nav];
    
}






@end
