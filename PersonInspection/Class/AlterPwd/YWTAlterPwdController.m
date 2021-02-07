//
//  YWTAlterPwdController.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/11.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTAlterPwdController.h"
#import "YWAlterPwdModuleCell.h"
#import "YWTModuleBtnCell.h"

@interface YWTAlterPwdController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic,strong) YWAlterPwdModuleCell *oldPwdCell;

@property (nonatomic,strong) YWAlterPwdModuleCell *newsPwdCell;
// 确定密码
@property (nonatomic,strong) YWAlterPwdModuleCell *confirmPwdCell;

@property (nonatomic,strong) YWTModuleBtnCell *moduleBtnCell;

@property (nonatomic,strong) UITableView *alterTableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation YWTAlterPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
    // 设置导航栏
    [self setNavi];
    
    [self.dataArr addObject:self.oldPwdCell];
    [self.dataArr addObject:self.newsPwdCell];
    [self.dataArr addObject:self.confirmPwdCell];
    [self.dataArr addObject:self.moduleBtnCell];
    
    [self.view addSubview:self.alterTableView];
}
-(void)selectAlterBtn:(UIButton*)sender{
    if (self.oldPwdCell.moduleTextF.text.length == 0) {
        [self.view showErrorWithTitle:@"请输入原密码"];
        return;
    }
    if (self.newsPwdCell.moduleTextF.text.length == 0) {
        [self.view showErrorWithTitle:@"请输入新密码"];
        return;
    }
    if (self.newsPwdCell.moduleTextF.text.length < 6) {
        [self.view showErrorWithTitle:@"新密码少于6位"];
        return;
    }
    if (self.confirmPwdCell.moduleTextF.text.length == 0) {
        [self.view showErrorWithTitle:@"请输入确认密码"];
        return;
    }
    if (self.confirmPwdCell.moduleTextF.text.length < 6) {
        [self.view showErrorWithTitle:@"确认密码少于6位"];
        return;
    }
    if (![self.confirmPwdCell.moduleTextF.text isEqualToString:self.newsPwdCell.moduleTextF.text]) {
        [self.view showErrorWithTitle:@"确认密码与新密码不一样"];
        return;
    }
    [self requestAlterPwd];
}
#pragma  mark ---------------- UITableViewDataSource --------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.dataArr[indexPath.row];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        return KSIphonScreenH(110);
    }else {
        return KSIphonScreenH(60);
    }
}
#pragma  mark ----------------  设置导航栏--------------------
-(void) setNavi{
    [self.customNavBar wr_setBackgroundAlpha:1];
    self.customNavBar.title =@"修改密码";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_btn_back"]];
    WS(weakSelf);
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
-(void) touchTapleView{
    [self.view endEditing:YES];
}
#pragma  mark ----------------  get 方法 --------------------
-(UITableView *)alterTableView{
    if (!_alterTableView) {
        _alterTableView  =[[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-KSTabbarH)];
        _alterTableView.delegate = self;
        _alterTableView.dataSource = self;
        _alterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _alterTableView.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
        _alterTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        if (@available(iOS 11.0, *)) {
           _alterTableView.estimatedRowHeight = 0;
           _alterTableView.estimatedSectionFooterHeight = 0;
            _alterTableView.estimatedSectionHeaderHeight = 0 ;
            _alterTableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTapleView)];
        tap.cancelsTouchesInView = NO;
        [_alterTableView addGestureRecognizer:tap];
      
    }
    return _alterTableView;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(YWAlterPwdModuleCell *)oldPwdCell{
    if (!_oldPwdCell) {
        _oldPwdCell = [[YWAlterPwdModuleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OLDCELL"];
        _oldPwdCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _oldPwdCell.moduleTitleLab.text = @"原密码";
        _oldPwdCell.modulePlaceholderText = @"请输入初始密码";
    }
    return _oldPwdCell;
}
-(YWAlterPwdModuleCell *)newsPwdCell{
    if (!_newsPwdCell) {
        _newsPwdCell = [[YWAlterPwdModuleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NEWSCELL"];
        _newsPwdCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _newsPwdCell.moduleTitleLab.text = @"新密码";
        _newsPwdCell.modulePlaceholderText = @"请输入新密码";
    }
    return _newsPwdCell;
}
-(YWAlterPwdModuleCell *)confirmPwdCell{
    if (!_confirmPwdCell) {
        _confirmPwdCell = [[YWAlterPwdModuleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CONFIRMCELL"];
        _confirmPwdCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _confirmPwdCell.moduleTitleLab.text = @"确认密码";
        _confirmPwdCell.modulePlaceholderText = @"请再次确认新密码";
    }
    return _confirmPwdCell;
}
-(YWTModuleBtnCell *)moduleBtnCell{
    if (!_moduleBtnCell) {
        _moduleBtnCell = [[YWTModuleBtnCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MODULEBTN"];
        _moduleBtnCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _moduleBtnCell.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
        [_moduleBtnCell.moduleBtn setTitle:@"确定修改" forState:UIControlStateNormal];
        [_moduleBtnCell.moduleBtn addTarget:self action:@selector(selectAlterBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moduleBtnCell;
}

#pragma mark ---  数据相关 ------
-(void) requestAlterPwd{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"old_pwd"] = [YWTTools base64EncodeString:self.oldPwdCell.moduleTextF.text];
    param[@"password"] = [YWTTools base64EncodeString:self.newsPwdCell.moduleTextF.text];
    param[@"conf_pwd"] = [YWTTools base64EncodeString:self.confirmPwdCell.moduleTextF.text];
    
    [[YWTHttpManager sharedManager]postRequestUrl:HTTP_ATTAPPUSERPWD_URL params:param waitView:self.view complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
        if (error) {
            [self.view showErrorWithTitle:error];
            return;
        }
        // 删除用户信息
        [YWTLoginManager delLoginModel];
        
        AppDelegate *appdel = (AppDelegate*)[UIApplication sharedApplication].delegate;
        YWTLoginController *loginVC = [[YWTLoginController alloc]init];
        appdel.window.rootViewController = loginVC;
    }];
}




@end
