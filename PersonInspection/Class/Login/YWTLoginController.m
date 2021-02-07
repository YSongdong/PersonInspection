//
//  YWTLoginController.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/9.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTLoginController.h"
#import "YWTLoginLogoCell.h"
#import "YWTLoginAccountCell.h"
#import "YWTLoginPasswordCell.h"
#import "YWTLoginForgetPwdCell.h"
#import "YWTLoginBtnCell.h"

@interface YWTLoginController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic,strong) YWTLoginLogoCell      *mLogoCell;
@property (nonatomic,strong) YWTLoginAccountCell   *mAccountCell;
@property (nonatomic,strong) YWTLoginPasswordCell  *mPasswordCell;
@property (nonatomic,strong) YWTLoginForgetPwdCell *mForgetPwdCell;
@property (nonatomic,strong) YWTLoginBtnCell       *mBtnCell;

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) UITableView *loginTableView;
@end

@implementation YWTLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    
    [self.dataArr addObject:self.mLogoCell];
    [self.dataArr addObject:self.mAccountCell];
    [self.dataArr addObject:self.mPasswordCell];
    [self.dataArr addObject:self.mForgetPwdCell];
    [self.dataArr addObject:self.mBtnCell];
    
    [self.view addSubview:self.loginTableView];
}
// 点击登录按钮
-(void) clickLoginBtn{
    if (self.mAccountCell.accountTextField.text.length == 0) {
        [self.view showErrorWithTitle:@"请输入账号"];
        return;
    }
    if (self.mPasswordCell.pwdTextField.text.length == 0) {
        [self.view showErrorWithTitle:@"请输入密码"];
        return;
    }
    if (self.mPasswordCell.pwdTextField.text.length < 6) {
        [self.view showErrorWithTitle:@"密码不少于6位"];
        return;
    }
    [self requestLogin];
}
-(void)selectTap{
    [self.view endEditing:YES];
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
        return KSIphonScreenH(320);
    }else if(indexPath.row == 3){
        return KSIphonScreenH(50);
    }else if(indexPath.row == 4){
        return KSIphonScreenH(80);
    }else{
        return KSIphonScreenH(60);
    }
}
#pragma  mark ----------------  get 方法 --------------------
-(UITableView *)loginTableView{
    if (!_loginTableView) {
        _loginTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-KSTabbarH)];
        _loginTableView.delegate = self;
        _loginTableView.dataSource = self;
        _loginTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
        _loginTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _loginTableView.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTap)];
        [_loginTableView addGestureRecognizer:tap];
        if (@available(iOS 11.0, *)) {
            _loginTableView.estimatedRowHeight = 0;
            _loginTableView.estimatedSectionFooterHeight = 0;
            _loginTableView.estimatedSectionHeaderHeight = 0 ;
            _loginTableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _loginTableView;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(YWTLoginLogoCell *)mLogoCell{
    if (!_mLogoCell) {
        _mLogoCell = [[YWTLoginLogoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LOGOCELL"];
        _mLogoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _mLogoCell;
}
-(YWTLoginAccountCell *)mAccountCell{
    if (!_mAccountCell) {
        _mAccountCell = [[YWTLoginAccountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ACCOUNTCELL"];
        _mAccountCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _mAccountCell;
}
-(YWTLoginPasswordCell *)mPasswordCell{
    if (!_mPasswordCell) {
        _mPasswordCell = [[YWTLoginPasswordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PASSWORD"];
        _mPasswordCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _mPasswordCell;
}
-(YWTLoginForgetPwdCell *)mForgetPwdCell{
    if (!_mForgetPwdCell) {
        _mForgetPwdCell = [[YWTLoginForgetPwdCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FORGETPWD"];
        _mForgetPwdCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _mForgetPwdCell;
}
-(YWTLoginBtnCell *)mBtnCell{
    if (!_mBtnCell) {
        _mBtnCell = [[YWTLoginBtnCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BTNCELL"];
        _mBtnCell.selectionStyle = UITableViewCellSelectionStyleNone;
        WS(weakSelf);
        _mBtnCell.clickLoginBtn = ^{
            [weakSelf clickLoginBtn];
        };
    }
    return _mBtnCell;
}

#pragma mark -------    登录 --------
-(void) requestLogin{
    NSMutableDictionary *parma = [NSMutableDictionary dictionary];
    parma[@"username"] = self.mAccountCell.accountTextField.text;
    parma[@"password"] =[YWTTools base64EncodeString:self.mPasswordCell.pwdTextField.text];
    [[YWTHttpManager sharedManager]postRequestUrl:HTTP_ATTAPPUSERLOGIN_URL params:parma waitView:self.view complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
        if (error) {
            [self.view showErrorWithTitle:error];
            return;
        }
        NSDictionary *data = showdata[@"data"];
        //删除用户信息
        [YWTLoginManager delLoginModel];
        // 保存用户信息
        [YWTLoginManager saveLoginModel:data];
        
        AppDelegate *appdel = (AppDelegate*)[UIApplication sharedApplication].delegate;
        YWTHomeController *homeVC = [[YWTHomeController alloc]init];
        YWTNavigtationController *navi = [[YWTNavigtationController alloc]initWithRootViewController:homeVC];
        appdel.window.rootViewController = navi;
    }];
}






@end
