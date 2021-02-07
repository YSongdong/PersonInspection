//
//  YWTSearchResultController.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/14.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTResultDetailController.h"

#import "YWTAddRecordSceneController.h"

#import "YWTResultBottomView.h"

#import "YWTSearchResultStatuCell.h"
#import "YWTSearchResultPersonCell.h"
#import "YWTSearchResultIDCell.h"

@interface YWTResultDetailController ()
<
UITableViewDelegate,
UITableViewDataSource,
YWTResultBottomViewDelegate
>

@property (nonatomic,strong) YWTResultBottomView *bottomView;
@property (nonatomic,strong) UITableView *resultTableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation YWTResultDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
    //设置导航栏
    [self setNavi];
    
    [self.view addSubview:self.bottomView];
    
    [self.view addSubview:self.resultTableView];
    
}
#pragma  mark ---------------- UITableViewDataSource --------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        YWTSearchResultStatuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STATUCELL" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dict = self.dataArr[indexPath.row];
        return cell;
    }else {
        YWTSearchResultIDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IDCELL" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dict = self.dataArr[indexPath.row];
        return cell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return KSIphonScreenH(35);
    }else {
        return KSIphonScreenH(398);
    }
}
#pragma  mark ----------------  按钮点击事件 --------------------
-(void) pushRecordBtn{
    NSDictionary *dict = [self.dataArr lastObject];
    // 状态:1-正常;2-异常 ,
    NSString *statusStr = [NSString stringWithFormat:@"%@",dict[@"status"]];
    if ([statusStr isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        YWTAddRecordSceneController *addRecordVC = [[YWTAddRecordSceneController alloc]init];
        // 记录id
        if ([[self.dict allKeys] containsObject:@"record_id"]) {
             self.model.record_id = [NSString stringWithFormat:@"%@",dict[@"record_id"]];
        }
        self.model.errorMsg = [NSString stringWithFormat:@"%@",self.dict[@"message"]];
        self.model.certificate_name = [NSString stringWithFormat:@"%@",self.dict[@"certificate_name"]];
        self.model.certificate_url = [NSString stringWithFormat:@"%@",self.dict[@"certificate_url"]];
        addRecordVC.model = self.model;
        [self.navigationController pushViewController:addRecordVC animated:YES];
    }
}
-(void) pushBackBtn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma  mark ----------------  设置导航栏--------------------
-(void) setNavi{
    [self.customNavBar wr_setBackgroundAlpha:1];
    self.customNavBar.title =@"证件详情";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_btn_back"]];
    WS(weakSelf);
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
#pragma mark -------  get 方法 ------
-(UITableView *)resultTableView{
    if (!_resultTableView) {
        _resultTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSTabbarH-KSIphonScreenH(65)-KSNaviTopHeight)];
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        _resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _resultTableView.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
        [_resultTableView registerClass:[YWTSearchResultStatuCell class] forCellReuseIdentifier:@"STATUCELL"];
        [_resultTableView registerClass:[YWTSearchResultPersonCell class] forCellReuseIdentifier:@"PERSONCELL"];
        [_resultTableView registerClass:[YWTSearchResultIDCell class] forCellReuseIdentifier:@"IDCELL"];
    }
    return _resultTableView;
}
-(YWTResultBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[YWTResultBottomView alloc]initWithFrame:CGRectMake(0, KScreenH-KSIphonScreenH(65)-KSTabbarH, KScreenW, KSIphonScreenH(65))];
        _bottomView.delegate = self;
    }
    return _bottomView;
}
-(void)setStatuStr:(NSString *)statuStr{
    _statuStr = statuStr;
    if ([statuStr isEqualToString:@"2"]) {
        // 异常
        WS(weakSelf);
        [self.resultTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(weakSelf.view).offset(KSNaviTopHeight);
               make.left.right.equalTo(weakSelf.view);
               make.bottom.equalTo(weakSelf.view).offset(-KSTabbarH);
         }];
    }
}
-(void)setModel:(YWTCertificateModel *)model{
    _model = model;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(void)setIsRecord:(BOOL)isRecord{
    _isRecord = isRecord;
    if (isRecord) {
        WS(weakSelf);
        [self.resultTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).offset(KSNaviTopHeight);
            make.left.right.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view).offset(-KSTabbarH);
        }];
    }
}
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    // 状态:1-正常;2-异常 ,
    NSString *statusStr = [NSString stringWithFormat:@"%@",dict[@"status"]];
    if ([statusStr isEqualToString:@"1"]) {
        [self.bottomView.recordBtn setTitle:@"继续查询" forState:UIControlStateNormal];
    }
    
    NSMutableDictionary *promptDict = [NSMutableDictionary dictionary];
    promptDict[@"message"] =  dict[@"message"];
    promptDict[@"status"] =  dict[@"status"];
    [self.dataArr addObject:promptDict];
    
    [self.dataArr addObject:dict];
    
    [self.resultTableView reloadData];
}


@end
