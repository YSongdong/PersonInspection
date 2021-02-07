//
//  YWTRecognResultController.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/19.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTRecognResultController.h"

#import "YWTResultListController.h"
#import "YWTAddRecordSceneController.h"
#import "YWTBaseQueryController.h"
#import "YWTSearchResultController.h"

#import "YWTRecognBottomView.h"
#import "HQPickerView.h"
#import "YWTInquiryRecordView.h"
#import "YWTResultHeaderView.h"

#import "YWTRecognResultIDCell.h"
#define RESULTIDCELL @"YWTRecognResultIDCell"
#import "YWTRecognModuleCell.h"
#import "YWTInquiryRecordCell.h"
#define INQUIRYRECORDCELL @"YWTInquiryRecordCell"

@interface YWTRecognResultController ()
<
UITableViewDelegate,
UITableViewDataSource,
HQPickerViewDelegate,
WebSocketManagerDelegate
>
@property (nonatomic,strong) UITableView *resultTableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) YWTRecognBottomView *bottomView;
@property (nonatomic,strong) YWTResultHeaderView *headerView;
// 选择器
@property (nonatomic,strong) HQPickerView *hqPickerView;
// 证件类别
@property (nonatomic,strong) YWTRecognResultIDCell *recognResultCell;
// 姓名
@property (nonatomic,strong) YWTRecognModuleCell *nameModuleCell;
//证件号码
@property (nonatomic,strong) YWTRecognModuleCell *idNumberModuleCell;

@property (nonatomic,strong) MBProgressHUD *HUD;
@end

@implementation YWTRecognResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
    // 设置导航栏
    [self setNavi];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.resultTableView];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[YWTWebSocketManager shared]RMWebSocketClose];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataArr[section];
    return arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        YWTInquiryRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:INQUIRYRECORDCELL forIndexPath:indexPath];
        NSArray *arr = self.dataArr[indexPath.section];
        cell.dict = arr[indexPath.row];
        return cell;
    }else{
        if (indexPath.row == 1) {
            self.idNumberModuleCell = [YWTRecognModuleCell  cellWithTableView:tableView style:UITableViewCellStyleDefault radius:10 indexPath:indexPath];
            self.idNumberModuleCell.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
            self.idNumberModuleCell.lineView.hidden = YES;
            self.idNumberModuleCell.baseTitleLab.text = @"证件号码";
            self.idNumberModuleCell.itmeTextF.placeholder = @"请输入";
            self.idNumberModuleCell.itmeTextF.text = self.dataDict[@"certificate_num"];
            __weak typeof(self) weakSelf = self;
            self.idNumberModuleCell.finishText = ^(NSString * _Nonnull text) {
                NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:weakSelf.dataDict];
                mutableDict[@"certificate_num"] = text;
                weakSelf.dataDict =  mutableDict.copy;
            };
            return self.idNumberModuleCell;
        }else if(indexPath.row == 0){
            self.nameModuleCell = [YWTRecognModuleCell  cellWithTableView:tableView style:UITableViewCellStyleDefault radius:10 indexPath:indexPath];
            self.nameModuleCell.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
            self.nameModuleCell.baseTitleLab.text = @"姓名";
            self.nameModuleCell.itmeTextF.placeholder = @"请输入";
            self.nameModuleCell.itmeTextF.text = self.dataDict[@"name"];
            __weak typeof(self) weakSelf = self;
            self.nameModuleCell.finishText = ^(NSString * _Nonnull text) {
                NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:weakSelf.dataDict];
                mutableDict[@"name"] = text;
                weakSelf.dataDict =  mutableDict.copy;
            };
            return self.nameModuleCell;
        }else{
            self.recognResultCell = [YWTRecognResultIDCell cellWithTableView:tableView style:UITableViewCellStyleDefault radius:10 indexPath:indexPath];
            self.recognResultCell.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
            self.recognResultCell.baseTitleLab.text = @"证件类别";
            self.recognResultCell.baseSubTiltlLab.text = @"请选择";
            
            if (self.dataDict == nil) {
                return self.recognResultCell;
            }
            if (![self.dataDict[@"certificate_name"] isEqualToString:@""]) {
                self.recognResultCell.baseSubTiltlLab.text =  self.dataDict[@"certificate_name"];
                self.recognResultCell.baseSubTiltlLab.textColor = [UIColor colorNamlCommonTextColor];
            }
            return self.recognResultCell;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return KSIphonScreenH(60);
    }else{
        return KSIphonScreenH(40);
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return KSIphonScreenH(7);
    }else{
        return KSIphonScreenH(35);
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        YWTInquiryRecordView *headerView = [[YWTInquiryRecordView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 0)];
        return headerView;
    }else{
        return nil;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            [self.view endEditing:YES];
            [self createHQPickerView];
        }
    }else{
        NSArray *arr = self.dataArr[indexPath.section];
        NSDictionary *dict = arr[indexPath.row];
       
        YWTCertificateModel *model1 = [YWTCertificateModel yy_modelWithDictionary:dict];
        self.model = model1;
        
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:self.dataDict];
        mutableDict[@"certificate_num"] = dict[@"certificate_num"];
        mutableDict[@"name"] = dict[@"name"];
        mutableDict[@"certificate_name"] = dict[@"certificate_name"];
        self.dataDict =  mutableDict.copy;
    }
}
- (void)willMoveToParentViewController:(UIViewController*)parent{
    [super willMoveToParentViewController:parent];
    if (parent == nil) {
        NSArray *viewS = self.navigationController.viewControllers;
        NSMutableArray * mTmp = [NSMutableArray array];
        [mTmp addObject:[viewS firstObject]];
        [mTmp addObject:[viewS lastObject]];
        self.navigationController.viewControllers = (NSArray*)mTmp;
    }
}
- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
}

#pragma  mark ---------------- bottomView  按钮点击方法  --------------------
-(void)selectSearch:(UIButton*)sender{
    if ([self.dataDict[@"certificate_name"] isEqualToString:@""]) {
        //
        [self.view showErrorWithTitle:@"请选择证件类型!"];
        return;
    }
    if (self.nameModuleCell.itmeTextF.text.length == 0) {
        [self.view showErrorWithTitle:@"请输入姓名!"];
        return;
    }
    if (self.idNumberModuleCell.itmeTextF.text.length == 0 ) {
        [self.view showErrorWithTitle:@"请输入证件号码!"];
        return;
    }
    if (self.idNumberModuleCell.itmeTextF.text.length < 18 ) {
        [self.view showErrorWithTitle:@"证件号码不能少于18位!"];
        return;
    }
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
    self.HUD.contentColor = [UIColor colorWithWhite:1 alpha:1];
    self.HUD.bezelView.blurEffectStyle = UIBlurEffectStyleLight;
    
    // 连接webSocket
    [[YWTWebSocketManager shared] connectServer];
    [YWTWebSocketManager shared].delegate = self;
}
// 重新识别
-(void)selectAgain:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma  mark ---------------- 连接WebSocket --------------------
-(void) sendDataWebSocket{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    mutableDict[@"code"]= [NSNumber numberWithInteger:202];
    mutableDict[@"unit"] = [NSNumber numberWithInteger:2];
    //
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSString *uidStr = [userD objectForKey:@"UidKey"];
    mutableDict[@"uid"] = uidStr;
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    dataDict[@"user_id"] = [YWTLoginManager obtainWithUserId];
    if (self.isEnter) {
        dataDict[@"name"] = self.nameModuleCell.itmeTextF.text;
        dataDict[@"certificate_url"] = @"";
        dataDict[@"face_url"] = @"";
        dataDict[@"certificate_type"] =  self.model.certificate_name;
        dataDict[@"certificate_name"] =  self.model.certificate_name;
        dataDict[@"certificate_num"] =self.idNumberModuleCell.itmeTextF.text;
        dataDict[@"id_card"] = self.idNumberModuleCell.itmeTextF.text;
    }else{
        dataDict[@"name"] =  self.model.name;
        dataDict[@"certificate_url"] =  self.model.certificate_url;
        dataDict[@"face_url"] =  self.model.face_url;
        dataDict[@"certificate_type"] =  self.model.certificate_name;
        dataDict[@"certificate_name"] =  self.model.certificate_name;
        dataDict[@"certificate_num"] = self.model.certificate_num;
        dataDict[@"id_card"] =  self.model.id_card;
    }
    mutableDict[@"data"] = dataDict;
    
    // 记录本地
    [YWTRecordFileManager getWritePlistFile:dataDict];

    // 字典转字符串
    NSString *jsonStr = [YWTTools convertToJsonData:mutableDict];
    // 发送消息给服务器
    [[YWTWebSocketManager shared] sendDataToServer:jsonStr];
}
// 连接失败
-(void) connectionWebSocketError:(NSString *)msg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.HUD hideAnimated:YES];
        [self.view showErrorWithTitle:msg];
    });
}
// 验证webSocket成功回调
-(void) verificationWebSocketSuccess{
    // 发送信息给WebSocket
    [self sendDataWebSocket];
}
// 接收到WebSocket数据
-(void)webSocketManagerDidReceiveMessageWithDict:(NSDictionary *)dict{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.HUD hideAnimated:YES];
    });
    if (self.isEnter) {
        self.model.name = [NSString stringWithFormat:@"%@",dict[@"name"]];
        self.model.certificate_type = self.model.certificate_name;
        self.model.certificate_num = [NSString stringWithFormat:@"%@",dict[@"certificate_num"]];
        self.model.id_card = [NSString stringWithFormat:@"%@",dict[@"id_card"]];
        self.model.record_id = [NSString stringWithFormat:@"%@",dict[@"record_id"]];
    }
    YWTSearchResultController *resultVC = [[YWTSearchResultController alloc]init];
    resultVC.model = self.model;
    resultVC.webDataSource = dict;
    resultVC.isAccurateQuery = self.isAccurateQuery;
    [self.navigationController pushViewController:resultVC animated:YES];
}
#pragma  mark ---------------- 创建 HQPickerView--------------------
-(void) createHQPickerView{
    NSArray *arr = self.dataDict[@"type"];
    NSMutableArray *keyArr = [NSMutableArray array];
    for (int i=0; i<arr.count; i++) {
        NSDictionary  *dict = arr[i];
        NSString *keyStr = dict[@"name"];
        [keyArr addObject:keyStr];
    }
    if (keyArr.count == 0) {
        return;
    }
    self.hqPickerView = [[HQPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-KSTabbarH)];
    self.hqPickerView.delegate = self;
    self.hqPickerView.customArr = keyArr;
    [self.view addSubview:self.hqPickerView];
}
//     -------- HQPickerViewDelegate ---
- (void)pickerView:(UIPickerView *)pickerView didSelectText:(NSString *)text{
    _recognResultCell.baseSubTiltlLab.text = text;
    _recognResultCell.baseSubTiltlLab.textColor = [UIColor colorNamlCommonTextColor];
    // 保存选择的类型
    self.model.certificate_name = text;
    self.model.certificate_type = [self byDictKeyGetValue:text];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:self.dataDict];
    mutableDict[@"certificate_name"] = text;
    self.dataDict = mutableDict.copy;
}
// 通过字典key 获取值
-(NSString*) byDictKeyGetValue:(NSString*)keyStr{
    NSString *valueStr = [NSString string];
    NSArray *arr = self.dataDict[@"type"];
    for (int i=0; i<arr.count; i++) {
        NSDictionary  *dict = arr[i];
        NSString *key = dict[@"name"];
        if ([keyStr isEqualToString:key]) {
            valueStr = [NSString stringWithFormat:@"%@",dict[@"code"]];
        }
    }
    return valueStr;
}
#pragma  mark ----------------  设置导航栏  --------------------
-(void) setNavi{
    [self.customNavBar wr_setBackgroundAlpha:1];
    self.customNavBar.title =@"证件信息";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_btn_back"]];
    WS(weakSelf);
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
#pragma mark ---------------  get  ----------------
-(UITableView *)resultTableView{
    if (!_resultTableView) {
        _resultTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight+CGRectGetHeight(self.headerView.frame), KScreenW, KScreenH-KSNaviTopHeight-KSTabbarH-CGRectGetHeight(self.bottomView.frame)-CGRectGetHeight(self.headerView.frame)) style:UITableViewStyleGrouped];
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        _resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _resultTableView.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
        [_resultTableView registerClass:[YWTInquiryRecordCell class] forCellReuseIdentifier:INQUIRYRECORDCELL];
    }
    return _resultTableView;
}
-(YWTResultHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[YWTResultHeaderView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KSIphonScreenH(35))];
        _headerView.statuPromptLab.text = @"确认证件信息是否准确，若有误，可手动编辑修改";
    }
    return _headerView;
}
-(void)setIsAccurateQuery:(BOOL)isAccurateQuery{
    _isAccurateQuery = isAccurateQuery;
}
-(YWTRecognBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[YWTRecognBottomView alloc]initWithFrame:CGRectMake(0, KScreenH-KSTabbarH-KSIphonScreenH(180), KScreenW, KSIphonScreenH(180))];
        [_bottomView.inquireBtn setTitle:@"立即查询" forState:UIControlStateNormal];
        [_bottomView.inquireBtn addTarget:self action:@selector(selectSearch:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.identtifyBtn setTitle:@"重新识别" forState:UIControlStateNormal];
        [_bottomView.identtifyBtn addTarget:self action:@selector(selectAgain:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        NSMutableArray *idArr = [NSMutableArray array];
        [idArr addObject:@""];
        [idArr addObject:@""];
        [idArr addObject:@""];
        
        [self.dataArr addObject:idArr];
        NSMutableArray *recordArr = [NSMutableArray array];
        [recordArr addObjectsFromArray:[YWTRecordFileManager getObtainAllDataFilePath:[YWTRecordFileManager getObtainFilePath]]];
        [self.dataArr addObject:recordArr];
    }
    return _dataArr;
}
-(void)setDataDict:(NSMutableDictionary *)dataDict{
    _dataDict = dataDict;
    [self.resultTableView reloadData];
}
-(void)setModel:(YWTCertificateModel *)model{
    _model = model;
}

-(void)setIsEnter:(BOOL)isEnter{
    _isEnter = isEnter;
    if (isEnter) {
        [self requestClickJumpData];
    }
}
#pragma mark ----  数据相关 -----
-(void) requestClickJumpData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [[YWTHttpManager sharedManager] postRequestUrl:HTTP_ATTAPPBUSINESCLICKJUMP params:param waitView:self.view complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
        if (error) {
            [self.view showErrorWithTitle:error];
            return;
        }
        NSDictionary *data = showdata[@"data"];
    
        self.dataDict =  data;
    }];
}








@end
