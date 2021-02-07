//
//  YWTUserController.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/11.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTUserController.h"

#import "YWTAlterPwdController.h"
#import "YWTResultListController.h"

#import "YWTUpdateView.h"

#import "YWTUserInfoCell.h"
#import "YWTUserModuleCell.h"
#import "YWTModuleBtnCell.h"

@interface YWTUserController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic,strong) YWTUserInfoCell *userInfoCell;
@property (nonatomic,strong) YWTUserModuleCell *recordModuleCell;
@property (nonatomic,strong) YWTUserModuleCell *pwdModuleCell;
@property (nonatomic,strong) YWTUserModuleCell *upgradeModuleCell;
@property (nonatomic,strong) YWTModuleBtnCell *signOutCell;


@property (nonatomic,strong) UITableView *userTableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

// 版本更新view
@property (nonatomic,strong) YWTUpdateView *updateView;
@end

@implementation YWTUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
    //  设置导航栏
    [self setNavi];
    
    [self.dataArr addObject:self.userInfoCell];
    [self.dataArr addObject:self.recordModuleCell];
    [self.dataArr addObject:self.pwdModuleCell];
    [self.dataArr addObject:self.upgradeModuleCell];
    [self.dataArr addObject:self.signOutCell];
    
    [self.view insertSubview:self.userTableView atIndex:0];
    
    [self requestUserInfo];
}
#pragma  mark ---------------- UITableViewDataSource --------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.dataArr[indexPath.row];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 370;
    }else if (indexPath.row == 4) {
        return KSIphonScreenH(80);
    }else{
        return KSIphonScreenH(70);
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        YWTResultListController *listVC = [[YWTResultListController alloc]init];
         [self.navigationController pushViewController:listVC animated:YES];
    }else if (indexPath.row == 2) {
        YWTAlterPwdController *alterVC = [[YWTAlterPwdController alloc]init];
        [self.navigationController pushViewController:alterVC animated:YES];
    }
}
// 退出登录
-(void) signOutBtn:(UIButton*)sender{
    // 删除用户信息
    [YWTLoginManager delLoginModel];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    YWTLoginController *loginVC = [[YWTLoginController alloc]init];
    appDelegate.window.rootViewController = loginVC;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma  mark ----------------  设置导航栏--------------------
-(void) setNavi{
    [self.customNavBar wr_setBackgroundAlpha:0];
    self.customNavBar.title =@"个人中心";
    self.customNavBar.titleLabelColor = [UIColor colorTextWhiteColor];
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_btn_04"]];
    WS(weakSelf);
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
#pragma  mark ----------------  get 方法 --------------------
-(UITableView *)userTableView{
    if (!_userTableView) {
        _userTableView  =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-KSTabbarH)];
        _userTableView.delegate = self;
        _userTableView.dataSource = self;
        _userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _userTableView.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
        if (@available(iOS 11.0, *)) {
           _userTableView.estimatedRowHeight = 0;
           _userTableView.estimatedSectionFooterHeight = 0;
            _userTableView.estimatedSectionHeaderHeight = 0 ;
            _userTableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
       }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _userTableView;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(YWTUpdateView *)updateView{
    if (!_updateView) {
        _updateView = [[YWTUpdateView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-KSTabbarH)];
    }
    return _updateView;
}
-(YWTUserInfoCell *)userInfoCell{
    if (!_userInfoCell) {
        _userInfoCell = [[YWTUserInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"INFOCELL"];
        _userInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _userInfoCell.nameLab.text = [YWTLoginManager obtainWithRealName];
    }
    return _userInfoCell;
}
-(YWTUserModuleCell *)recordModuleCell{
    if (!_recordModuleCell) {
        _recordModuleCell = [[YWTUserModuleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RECORDCELL"];
        _recordModuleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _recordModuleCell.moduleImageV.image = [UIImage imageNamed:@"ico_grzx_03"];
        _recordModuleCell.moduleNameLab.text = @"历史查询记录";
    }
    return _recordModuleCell;
}
-(YWTUserModuleCell *)pwdModuleCell{
    if (!_pwdModuleCell) {
        _pwdModuleCell = [[YWTUserModuleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PWDCELL"];
        _pwdModuleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _pwdModuleCell.moduleImageV.image = [UIImage imageNamed:@"ico_grzx_04"];
        _pwdModuleCell.moduleNameLab.text = @"修改密码";
    }
    return _pwdModuleCell;
}
-(YWTUserModuleCell *)upgradeModuleCell{
    if (!_upgradeModuleCell) {
        _upgradeModuleCell = [[YWTUserModuleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UPGRADECELL"];
        _upgradeModuleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _upgradeModuleCell.moduleImageV.image = [UIImage imageNamed:@"ico_grzx_09"];
        _upgradeModuleCell.moduleNameLab.text = @"升级";
        //获取本地软件的版本号
        NSString *localVersion =  [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        _upgradeModuleCell.moduleSubLab.text = localVersion;
    }
    return _upgradeModuleCell;
}
-(YWTModuleBtnCell *)signOutCell{
    if (!_signOutCell) {
        _signOutCell = [[YWTModuleBtnCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MODULEBTN"];
        _signOutCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [_signOutCell.moduleBtn addTarget:self action:@selector(signOutBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signOutCell;
}

#pragma mark --- 数据相关 ----------
-(void) requestUserInfo{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [[YWTHttpManager sharedManager] getRequestUrl:HTTP_ATTAPPUSERINFO_URL params:param waitView:self.view complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
        if (error) {
            [self.view showErrorWithTitle:error];
            return;
        }
        id data = showdata[@"data"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            [self.view showErrorWithTitle:@"数据格式错误"];
            return;
        }
        NSDictionary *dict = (NSDictionary*)data;
        // 姓名
        self.userInfoCell.nameLab.text = dict[@"real_name"];
        // 公司名称
        self.userInfoCell.companyLab.text = dict[@"company_name"];
       // 部门
        self.userInfoCell.companyDepaLab.text = dict[@"organization_name"];
        // 头像
        [YWTTools sd_setImageView:self.userInfoCell.headerImageV WithURL:dict[@"head_image"] andPlaceholder:@"cbl_pic_user"];
        // 角色名称
        self.userInfoCell.jobTitleLab.text = dict[@"role_name"];
    
    }];
}
#pragma mark ---  判断是否显示更新View ----
-(void) requestDataIsShowUpdateView{
    //获取本地软件的版本号
    NSString *localVersion =  [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"system"] =  @"1";
    param[@"version"] = localVersion;
    param[@"appId"] = @"lhzjsb";
    [[YWTHttpManager sharedManager]postRequestUrl:HTTP_ATTENDANCESYSTEMUPGRADE_URL params:param waitView:self.view complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
        if (error) {
            return;
        }
        NSDictionary *data = (NSDictionary*)showdata[@"data"];
        //判断是否需要更新  false 不需要更新  true  需要更新
        if (![data[@"update"] boolValue]) {
            return;
        }
        //判断是否强制更新  1 强制更新 2 非强制更新
        NSString *forceStr = [NSString stringWithFormat:@"%@",data[@"force"]];
        [self.view addSubview:self.updateView];
        if ([forceStr isEqualToString:@"1"]) {
            self.updateView.typeStatu = updateTypeForceStatu;
        }
        self.updateView.contentLab.text = data[@"releaseNotes"];
        self.updateView.titleLab.text = [NSString stringWithFormat:@"发现新版本V%@版",data[@"version"]];
        [[UIApplication sharedApplication].keyWindow addSubview:self.updateView];
    }];
}






@end
