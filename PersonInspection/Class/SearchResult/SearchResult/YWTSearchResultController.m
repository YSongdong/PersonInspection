//
//  YWTSearchResultController.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/20.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTSearchResultController.h"

#import "YWTResultDetailController.h"
#import "YWTAddRecordSceneController.h"
#import "YWTBaseQueryController.h"

#import "YWTResultPromptView.h"
#import "YWTResultRefreshView.h"
#import "YWTResultBottomView.h"
#import "YWTBlankPageView.h"

#import "YWTSearchResultCell.h"
#define SEARCHRESULTCELL  @"YWTSearchResultCell"
#import "YWTSearchResultPersonCell.h"
#define RESULTPERSONCELL  @"YWTSearchResultPersonCell"

@interface YWTSearchResultController ()
<
UITableViewDelegate,
UITableViewDataSource,
YWTResultBottomViewDelegate,
YWTBlankPageViewDelegate,
WebSocketManagerDelegate
>
@property (nonatomic,strong)YWTBlankPageView *blankPageView;
@property (nonatomic,strong) YWTResultPromptView *promptView;
@property (nonatomic,strong) YWTResultRefreshView *fefresView;
@property (nonatomic,strong) YWTResultBottomView *bottomView;

@property (nonatomic,strong) UITableView *resultTableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) MBProgressHUD *HUD;

@end

@implementation YWTSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
    // 设置导航栏
    [self setNavi];
   
    [self.view addSubview:self.bottomView];
    
    [self.view addSubview:self.resultTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.isRecord) {
        // 指导跳转到页面
        [self getJumpDesigViewController];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[YWTWebSocketManager shared]RMWebSocketClose];
}
#pragma  mark ---------------- UITableViewDataSource --------------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        NSDictionary *dict = self.dataArr[section];
        NSArray *listArr = dict[@"list"];
        return listArr.count;
    }else{
        NSDictionary *dict = self.dataArr[section];
        NSArray *listArr = dict[@"certificate_list"];
        return listArr.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YWTSearchResultPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:RESULTPERSONCELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dict = self.dataArr[indexPath.section];
        NSArray *listArr = dict[@"list"];
        cell.dict = listArr[indexPath.row];
        return cell;
    }else{
        YWTSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:SEARCHRESULTCELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dict = self.dataArr[indexPath.section];
        NSArray *listArr = dict[@"certificate_list"];
        cell.dict = listArr[indexPath.row];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return KSIphonScreenH(160);
    }else {
        return KSIphonScreenH(200);
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        NSDictionary *dict = self.dataArr[section];
//        // 是否扫描证件状态：0-查无此证;1-正常；2-异常; ,
//        NSString *resultStatus = [NSString stringWithFormat:@"%@",dict[@"result_status"]];
//        if ([resultStatus isEqualToString:@"1"]) {
//            return nil;
//        }
        self.promptView = [[YWTResultPromptView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KSIphonScreenH(35))];
        self.promptView.dict = dict;
        return self.promptView;;
    }else{
        NSDictionary *dict = self.dataArr[section];
        NSArray *listArr = dict[@"certificate_list"];
        if (listArr.count > 0) {
            self.fefresView = [[YWTResultRefreshView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KSIphonScreenH(35))];
            self.fefresView.idNumberLab.text = [NSString stringWithFormat:@"(%lu)",(unsigned long)listArr.count];
            self.fefresView.isRecord = self.isRecord;
            WS(weakSelf);
            self.fefresView.selectRefreshBtn = ^{
                [weakSelf selectRefreshBtn];
            };
            return self.fefresView;
        }else{
            return nil;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        NSDictionary *dict = self.dataArr[section];
        NSArray *listArr = dict[@"certificate_list"];
        if (listArr.count > 0) {
            return KSIphonScreenH(35);
        }else{
            return 0.01;
        }
    }else{
//        NSDictionary *dict = self.dataArr[section];
//        // 是否扫描证件状态：0-查无此证;1-正常；2-异常; ,
//        NSString *resultStatus = [NSString stringWithFormat:@"%@",dict[@"result_status"]];
//        if ([resultStatus isEqualToString:@"1"]) {
//            return 0.01;
//        }else{
            return KSIphonScreenH(35);
//        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        // 本带数据
        NSDictionary *dataDict = self.dataArr[indexPath.section];
        NSArray *listArr = dataDict[@"certificate_list"];
        NSDictionary *dict = listArr[indexPath.row];
        YWTResultDetailController *detailVC = [[YWTResultDetailController alloc]init];
        // 记录id
        if ([[dict allKeys] containsObject:@"record_id"]) {
             self.model.record_id = [NSString stringWithFormat:@"%@",dict[@"record_id"]];
        }
        detailVC.dict = dict;
        NSString *statuStr= [NSString stringWithFormat:@"%@",dict[@"statu"]];
        detailVC.statuStr = statuStr;
        detailVC.isRecord = self.isRecord;
        detailVC.model = self.model;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
#pragma  mark ----------------  按钮点击事件 --------------------
-(void) pushRecordBtn{
    if ([self.model.result_status isEqualToString:@"3"]) {
        YWTAddRecordSceneController *addVC = [[YWTAddRecordSceneController alloc]init];
        NSString *resultStatusStr = [NSString stringWithFormat:@"%@",self.webDataSource[@"result_status"]];
        if ([resultStatusStr isEqualToString:@"2"] || [resultStatusStr isEqualToString:@"3"]) {
            self.model.errorMsg = [NSString stringWithFormat:@"%@",self.webDataSource[@"message"]];
        }
        addVC.model = self.model;
        [self.navigationController pushViewController:addVC animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(void) pushBackBtn{
    if ([self.model.result_status isEqualToString:@"3"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        YWTAddRecordSceneController *addVC = [[YWTAddRecordSceneController alloc]init];
        NSString *resultStatusStr = [NSString stringWithFormat:@"%@",self.webDataSource[@"result_status"]];
        if ([resultStatusStr isEqualToString:@"2"] || [resultStatusStr isEqualToString:@"3"]) {
            self.model.errorMsg = [NSString stringWithFormat:@"%@",self.webDataSource[@"message"]];
        }
        addVC.model = self.model;
        [self.navigationController pushViewController:addVC animated:YES];
    }
}
//  -----   YWTBlankPageViewDelegate  -----
-(void) pushPageRecordBtn{
    YWTAddRecordSceneController *addVC = [[YWTAddRecordSceneController alloc]init];
    NSString *resultStatusStr = [NSString stringWithFormat:@"%@",self.webDataSource[@"result_status"]];
    if ([resultStatusStr isEqualToString:@"2"] || [resultStatusStr isEqualToString:@"3"]) {
        self.model.errorMsg = [NSString stringWithFormat:@"%@",self.webDataSource[@"message"]];
    }
    addVC.model = self.model;
    [self.navigationController pushViewController:addVC animated:YES];
}
-(void) pushPageBackBtn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
// 指导跳转到页面
-(void) getJumpDesigViewController{
    NSArray *viewS = self.navigationController.viewControllers;
    NSMutableArray *mTmp = [NSMutableArray array];
    NSInteger index = 0;
    for (NSInteger i = viewS.count; i > 0; i--) {
        UIViewController *VC = viewS[i-1];
        if ([VC isKindOfClass:[YWTHomeController class]]) {
            index = i;
            break;
        }
    }
    for (NSInteger j = 0; j < index; j++) {
        [mTmp addObject:viewS[j]];
    }
    [mTmp addObject:[viewS lastObject]];
    self.navigationController.viewControllers = (NSArray*)mTmp;
}
#pragma  mark ---------------- bottomView  按钮点击方法  --------------------
-(void)selectRefreshBtn{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.bezelView.color = [UIColor colorWithWhite:0 alpha:0.7];
    self.HUD.contentColor = [UIColor colorWithWhite:1 alpha:1];
    // 连接webSocket
    [[YWTWebSocketManager shared] connectServer];
    [YWTWebSocketManager shared].delegate = self;
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
    dataDict[@"name"] =  self.model.name;
    dataDict[@"certificate_url"] = self.model.certificate_url;
    dataDict[@"face_url"] =  self.model.face_url;
    dataDict[@"certificate_type"] =  self.model.certificate_name;
    dataDict[@"certificate_num"] = self.model.certificate_num;
    dataDict[@"id_card"] =  self.model.id_card;
    dataDict[@"user_id"] = [YWTLoginManager obtainWithUserId];
    mutableDict[@"data"] = dataDict;

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
    self.webDataSource = dict;
}
#pragma  mark ----------------  设置导航栏--------------------
-(void) setNavi{
    [self.customNavBar wr_setBackgroundAlpha:1];
    self.customNavBar.title =@"查询结果";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_btn_back"]];
    WS(weakSelf);
    self.customNavBar.onClickLeftButton = ^{
        if (weakSelf.isRecord) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    };
}
-(void) updateDataAndUIDict:(NSDictionary*)dataDict{
    NSString *resultStatusStr = [NSString stringWithFormat:@"%@",dataDict[@"result_status"]];
    if ([resultStatusStr isEqualToString:@"2"] || [resultStatusStr isEqualToString:@"3"]) {
        self.model.errorMsg = [NSString stringWithFormat:@"%@",self.webDataSource[@"message"]];
    }
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
    infoDict[@"face_url"] =  dataDict[@"face_url"];
    infoDict[@"name"] =  dataDict[@"name"];
    infoDict[@"sex"] =  dataDict[@"sex"];
    infoDict[@"birth_date"] =  dataDict[@"birth_date"];
    infoDict[@"id_card"] =  dataDict[@"id_card"];
    infoDict[@"address"] =  dataDict[@"address"];
    infoDict[@"result_status"] =  dataDict[@"result_status"];
    [arr addObject:infoDict];
    NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
    userDict[@"list"] =arr;
    userDict[@"result_status"] = dataDict[@"result_status"];
    if ([resultStatusStr isEqualToString:@"1"]) {
        userDict[@"title"] = self.isAccurateQuery == YES ? @"精准查询-（人证合一）" :@"快速查询-（有效证件）";
    }else{
        NSString *msg;
        if (self.isAccurateQuery) {
            msg = [NSString stringWithFormat:@"精准查讯- (%@)",dataDict[@"message"]];
        }else{
            msg = [NSString stringWithFormat:@"快速查询- (%@)",dataDict[@"message"]];
        }
        userDict[@"title"] =msg;
    }
    [self.dataArr addObject:userDict];
    
    NSArray *listArr = dataDict[@"certificate_list"];
    NSMutableDictionary *listDict = [NSMutableDictionary  dictionary];
    listDict[@"count"] = [NSString stringWithFormat:@"%lu",(unsigned long)listArr.count];
    listDict[@"certificate_list"] = listArr;
    [self.dataArr addObject:listDict];
    
    [self.resultTableView reloadData];
}
#pragma  mark ----------------  get  --------------------
-(UITableView *)resultTableView{
    if (!_resultTableView) {
        _resultTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-KSTabbarH-KSIphonScreenH(70)) style:UITableViewStyleGrouped];
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        _resultTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
        _resultTableView.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
        [_resultTableView registerClass:[YWTSearchResultCell class] forCellReuseIdentifier:SEARCHRESULTCELL];
        [_resultTableView registerClass:[YWTSearchResultPersonCell class] forCellReuseIdentifier:RESULTPERSONCELL];
    }
    return _resultTableView;
}
-(YWTResultBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[YWTResultBottomView alloc]initWithFrame:CGRectMake(0, KScreenH-KSIphonScreenH(70)-KSTabbarH, KScreenW, KSIphonScreenH(70))];
        _bottomView.delegate = self;
        if ([self.model.result_status isEqualToString:@"3"]) {
            [_bottomView.recordBtn setTitle:@"记录现场" forState:UIControlStateNormal];
            [_bottomView.homeBtn setTitle:@"回到首页" forState:UIControlStateNormal];
        }else{
            [_bottomView.recordBtn setTitle:@"继续查询" forState:UIControlStateNormal];
            [_bottomView.homeBtn setTitle:@"上报异常" forState:UIControlStateNormal];
        }
    }
    return _bottomView;
}
-(YWTBlankPageView *)blankPageView{
    if (!_blankPageView) {
        _blankPageView = [[YWTBlankPageView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-KSTabbarH)];
        _blankPageView.delegate = self;
    }
    return _blankPageView;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(void)setModel:(YWTCertificateModel *)model{
    _model = model;
}
-(void)setIsAccurateQuery:(BOOL)isAccurateQuery{
    _isAccurateQuery = isAccurateQuery;
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
-(void)setWebDataSource:(NSDictionary *)webDataSource{
    _webDataSource = webDataSource;
    // 移除数据源
    [self.dataArr removeAllObjects];
    
    // 记录id
    if ([[webDataSource allKeys] containsObject:@"record_id"]) {
         self.model.record_id = [NSString stringWithFormat:@"%@",webDataSource[@"record_id"]];
    }
    
    NSString *resultStatusStr = [NSString stringWithFormat:@"%@",webDataSource[@"result_status"]];
    self.model.result_status = resultStatusStr;
    if ([self.model.result_status isEqualToString:@"0"]) {
        [self.view addSubview:self.blankPageView];
        return;
    }
    [self updateDataAndUIDict:webDataSource];
}

-(void)setIdStr:(NSString *)idStr{
    _idStr = idStr;
    [self requestRecordDetail];
}
#pragma mark ------  数据相关 --------
-(void) requestRecordDetail{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = self.idStr;
    [[YWTHttpManager sharedManager] postRequestUrl:HTTP_ATTAPPBUSINESSQUERYRECORD params:param waitView:self.view complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {

        if (error) {
            [self.view showErrorWithTitle:error];
            return;
        }
        id data = showdata[@"data"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            [self.view showErrorWithTitle:@"数据结构错误!"];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        // 移除所有数据源
        [self.dataArr removeAllObjects];
        
        NSDictionary *dataDict = (NSDictionary*)data;
        // 0-查无此证;
        NSString *resultStatusStr = [NSString stringWithFormat:@"%@",dataDict[@"result_status"]];
        if ([resultStatusStr isEqualToString:@"0"]) {
            [self.view addSubview:self.blankPageView];
            return;
        }
        
        [self updateDataAndUIDict:dataDict];
    }];
}





@end
