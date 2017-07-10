//
//  MoreViewController.m
//  LotteryUnion
//
//  Created by 周文松 on 15/10/23.
//  Copyright © 2015年 TalkWeb. All rights reserved.
//

#import "MoreViewController.h"
#import "DataConfigManager.h"
#import "PJCollectionViewCell.h"
#import "AboutViewController.h"
#import "HelpManualVCViewController.h"
#import "SYJTabBarController.h"


@interface MoreCell :UITableViewCell

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) id datas;


@end

@implementation MoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _icon = [UIImageView new];
        _title = [UILabel new];
        _title.font = Font(16);
        _title.textColor = CustomBlack;
        _title.textAlignment = NSTextAlignmentLeft;

        [self.contentView addSubview:_icon];
        [self.contentView addSubview:_title];
        
        self.icon.sd_layout.leftSpaceToView(self.contentView, 8).centerYEqualToView(self.contentView).heightIs(30).widthIs(30);
        self.title.sd_layout.leftSpaceToView(self.icon, 8).centerYEqualToView(self.contentView).heightIs(20).widthIs(200);
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        
//        UIView *line = [[UIView alloc]init];
//        [self.contentView addSubview:line];
//        line.backgroundColor = Gray;
//        line.sd_layout.leftSpaceToView(self.contentView, 5).rightSpaceToView(self.contentView, 5).bottomSpaceToView(self.contentView, 1).heightIs(1);
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    return self;
}

- (void)setDatas:(id)datas
{
    _icon.image = mImageByName(datas[@"image"]);
    _title.text = datas[@"title"];
}

@end

@interface MoreViewController ()
<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSString *UpdateURL;
    NSString *ShareURL;
}
@end

@implementation MoreViewController

- (id)init
{
    if ((self = [super init])) {
        [self.navigationItem setNewTitle:@"更 多"];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _datas = [DataConfigManager getMoreList];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.userInteractionEnabled = YES;
    [_tableView registerClass:[MoreCell class] forCellReuseIdentifier:@"cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

#pragma mark - table view dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 24;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.datas = _datas[indexPath.section];
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section)
    {
        case 0:
            // 帮助指南
        {
            [self helpManalBook];
        }
            break;
        case 1:
            // 检查更新
        {
            [(SYJTabBarController *)self.tabBarController setSelected:1];
        }
            break;
        case 2:
            // 关于我们
        {
            [self aboutUs];
        }
            break;
        case 3:
            // 分享推荐
        {
            [SVProgressHUD showInfoWithStatus:@"把这么好用的app推广给身边的好友吧~~~"];
        }
            break;
        case 4:
            // 客服电话
        {
            [self callService];
        }
            break;
        default:
            break;
    }

}



//TODO:帮助指南
-(void)helpManalBook
{
    HelpManualVCViewController *help = [[HelpManualVCViewController alloc]init];
    help.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:help animated:YES];
}

//TODO:检测更新
- (void)checkVersionUpdate
{
    [SVProgressHUD showWithStatus:@"正在查询版本号~"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *date = [NS_USERDEFAULT objectForKey:@"msg_time"];      // 消息时间
    date = isValidateStr(date)?date:@"00000000000000";             // 判断时间是否为零
    NSString *vHelp = [NS_USERDEFAULT objectForKey:@"help_version"]; // 获取当前help版本号
    params[@"ver"] = getBuildVersion();
    params[@"help_version"] = vHelp?:GET_INT(HELP_VER);
    params[@"system"] = @"iOS"; // 系统类型
    params[@"display"] = [NSString stringWithFormat:@"%.0fx%.0f",mScreenWidth,mScreenHeight];  // 屏幕展示的大小
    params[@"phone_name"] = IsPhone?@"iPhone":@"iPad"; // 获取客户端类型
    params[@"msg_time"] = date ;// 消息时间
    params[@"client_id"] = client_id; // 获取客户端id
    [params setPublicDomain:kAPI_QueryVersion];
    
    NSLog(@"------\n%@",params);
    _connection = [RequestModel POST:URL(kAPI_QueryVersion) parameter:params   class:[RequestModel class]
                             success:^(id data)
                   {
                       [SVProgressHUD dismiss];
                       // 升级提示
                       NSString *cancel = [data objectForKey:@"force_update"]==0? nil : LocStr(@"取消");
                       
                       NSString *releaseNote = [data objectForKey:@"release_note"];
                       
                       // 判断版本是否有更新
                       if ([[data objectForKey:@"ver"] floatValue]>[getBuildVersion() floatValue]){
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocStr(@"升级提示") message:releaseNote delegate:self cancelButtonTitle:cancel otherButtonTitles:LocStr(@"确定"), nil];
                           /*保存下载地址*/
                           UpdateURL = [data objectForKey:@"url"];
                           /*分享地址*/
                           ShareURL = [data objectForKey:@"shore_url"];
                           
                           [alert setTag:10087];
                           [alert show];
                       }
                       else
                       {
                           [SVProgressHUD showInfoWithStatus:LocStr(@"您当前的版本为最新版本~")];
                       }
            
                   }
                             failure:^(NSString *msg, NSString *state)
                   {
                       [SVProgressHUD showErrorWithStatus:msg];
                       [SVProgressHUD dismiss];
                   }];
    
}
//TODO:关于我们
-(void)aboutUs
{
    AboutViewController *aboutUs = [[AboutViewController alloc]init];
    aboutUs.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aboutUs animated:YES];
    
}
//TODO:分享推荐
-(void)shareToFriend
{
    NSLog(@"=====%@",kkShareURLAddress);
    
}

//TODO:客服电话
-(void)callService
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"拨打 %@ 客服电话",kefuNumber] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
     alert.tag = 10086;
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10087&&buttonIndex == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UpdateURL]];
        
    }else if(alertView.tag==10086&&buttonIndex!=alertView.cancelButtonIndex){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",kefuNumber]]];
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
