//
//  SYJTabBarController.m
//  MoXiDemo
//
//  Created by 尚勇杰 on 2017/5/26.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "SYJTabBarController.h"
#import "SYJFirstController.h"
#import "SYJSecondController.h"
#import "SYJThirdController.h"
#import "SYJFourthController.h"
#import "SYJNavitionController.h"
#import "RunLotteryVC.h"
#import "MineVC.h"
#import "MoreViewController.h"
#import "UserInfo.h"

#define Text [UIColor colorWithRed:19.0/255.0 green:34/255.0 blue:122/ 255.0 alpha:1.0]


@interface SYJTabBarController ()<UITabBarControllerDelegate>{
    NSInteger _currentIndex;
}

@end

@implementation SYJTabBarController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    
    //
    SYJFirstController *main = [[SYJFirstController alloc]init] ;
    //    main.view.backgroundColor = [UIColor redColor];
    [self addChildVc:main Title:@"大厅" withTitleSize:12.0 andFoneName:@"DBLCDTempBlack" selectedImage:@"大厅1" withTitleColor:Text unselectedImage:@"大厅" withTitleColor:[UIColor lightGrayColor]];
    //
    RunLotteryVC  *caseVC = [[RunLotteryVC alloc]init];
    //    caseVC.view.backgroundColor = [UIColor grayColor];
    [self addChildVc:caseVC Title:@"开奖" withTitleSize:12.0 andFoneName:@"DBLCDTempBlack" selectedImage:@"开奖1" withTitleColor:Text unselectedImage:@"开奖" withTitleColor:[UIColor lightGrayColor]];
    //
    MineVC *fitVC = [[MineVC alloc]init];
    [self addChildVc:fitVC Title:@"个人中心" withTitleSize:12.0 andFoneName:@"DBLCDTempBlack" selectedImage:@"个人中心1" withTitleColor:Text unselectedImage:@"个人中心" withTitleColor:[UIColor lightGrayColor]];
    
    
    MoreViewController *MyVC = [[MoreViewController alloc]init];
    //    MyVC.view.backgroundColor = [UIColor purpleColor];
    [self addChildVc:MyVC Title:@"更多" withTitleSize:12.0 andFoneName:@"HelveticaNeue-Bold" selectedImage:@"更多1" withTitleColor:Text unselectedImage:@"更多" withTitleColor:[UIColor lightGrayColor]];
    
    
    // Do any additional setup after loading the view.
}


- (void)addChildVc:(UIViewController *)childVc
             Title:(NSString *)title
     withTitleSize:(CGFloat)size
       andFoneName:(NSString *)foneName
     selectedImage:(NSString *)selectedImage
    withTitleColor:(UIColor *)selectColor
   unselectedImage:(NSString *)unselectedImage
    withTitleColor:(UIColor *)unselectColor{
    childVc.title = title;
   // 设置图片
    childVc.tabBarItem  = [childVc.tabBarItem initWithTitle:title image:[[UIImage imageNamed:unselectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,NSFontAttributeName:[UIFont fontWithName:foneName size:size]} forState:UIControlStateNormal];
    
    //选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont fontWithName:foneName size:size]} forState:UIControlStateSelected];
    SYJNavitionController *nav = [[SYJNavitionController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
    
    /*
     //base64加密

    NSString *str = @"134567";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *sta = [data base64EncodedStringWithOptions:0];
    
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:sta options:0];
    
    // Decoded NSString from the NSData
    NSString *base64Decoded = [[NSString alloc]
                               initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
     */
}

- (void)setSelected:(NSInteger)index;
{
//    _currentIndex = 0;
    self.selectedIndex = index;
    
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UINavigationController *nav = (UINavigationController *)viewController;
    
    if ([nav.viewControllers[0] isKindOfClass:[MineVC class]])
    {
        BaseViewController *controller = (BaseViewController *)nav.viewControllers[0];
        
        
        
        if (!UserInfoTool.isLogined && !UserInfoTool.isLoginedWithVirefi)
        {
            [controller gotoLogingWithSuccess:^(BOOL isSuccess)
             {
                 if (isSuccess)
                 {
                     [controller.view makeToast:@"登录成功"];
                     _currentIndex = self.selectedIndex;
                     NSNotificationPost(RefreshWithViews, nil, nil);
                 }
                 else
                 {
                     self.selectedIndex = _currentIndex;
                 }
             }
                                        class:@"LoginVC"];
        }
        
    }
    else
    {
        _currentIndex = self.selectedIndex;
    }
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
