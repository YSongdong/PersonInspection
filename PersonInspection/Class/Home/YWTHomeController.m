//
//  YWTHomeController.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/9.
//  Copyright © 2020 世界之窗. All rights reserved.
//


#import "YWTHomeController.h"

#import <GPUImage/GPUImage.h>

#import "YWTUserController.h"
#import "YWTBaseQueryController.h"
#import "YWTResultListController.h"
#import "YWTAddRecordSceneController.h"
#import "YWTResultDetailController.h"
#import "YWTSearchResultController.h"

#import "YWTUpdateView.h"

#import "YWTHomeUserCell.h"
#import "YWTHomeMarkCell.h"
#import "YWTHomeModeCell.h"
#import "YWTHomeHistoryRecordCell.h"
#import <AudioToolbox/AudioToolbox.h>


@interface YWTHomeController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic,strong) YWTHomeUserCell *userCell;
@property (nonatomic,strong) YWTHomeMarkCell *markCell;
@property (nonatomic,strong) YWTHomeModeCell *preciseQueryCell;
@property (nonatomic,strong) YWTHomeModeCell *quickSearchCell;
@property (nonatomic,strong) YWTHomeHistoryRecordCell *historyRecordCell;

@property (nonatomic,strong) UITableView *homeTableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
// 版本更新view
@property (nonatomic,strong) YWTUpdateView *updateView;

@end

@implementation YWTHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    // 设置导航栏
    [self setNavi];
   
    [self.dataArr addObject:self.userCell];
    [self.dataArr addObject:self.markCell];
    [self.dataArr addObject:self.preciseQueryCell];
    [self.dataArr addObject:self.quickSearchCell];
    [self.dataArr addObject:self.historyRecordCell];
    [self.view addSubview:self.homeTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestDataIsShowUpdateView];
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
        return KSIphonScreenH(190);
    }else if(indexPath.row == 1){
        return KSIphonScreenH(80);
    }else if(indexPath.row == 4) {
        return KSIphonScreenH(160);
    }else  {
        return KSIphonScreenH(100);
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        [self playCilckVideo];
        [self requestGetAccuracyIsQuick:NO];
    }else if(indexPath.row == 3){
        [self playCilckVideo];
        [self requestGetAccuracyIsQuick:YES];
    }else if(indexPath.row == 4){
        [self playCilckVideo];
        YWTResultListController *listVC = [[YWTResultListController alloc]init];
        [self.navigationController pushViewController:listVC animated:YES];
    }
}
// 播放音频
-(void)playCilckVideo{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"click" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
    AudioServicesPlaySystemSound(soundID);
}
#pragma  mark ----------------  设置导航栏--------------------
-(void) setNavi{
    self.customNavBar.title =@"首页";
    
    WS(weakSelf);
    // 个人中心
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"nav_btn_user"]];
    self.customNavBar.onClickRightButton = ^{
        YWTUserController *userVC = [[YWTUserController alloc]init];
        [weakSelf.navigationController pushViewController:userVC animated:YES];
    };
}

#pragma  mark ----------------  get 方法 --------------------
-(UITableView *)homeTableView{
    if (!_homeTableView) {
        _homeTableView  =[[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-KSTabbarH)];
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homeTableView.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    }
    return _homeTableView;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(YWTHomeUserCell *)userCell{
    if (!_userCell) {
        _userCell = [[YWTHomeUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UERCELL"];
        _userCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _userCell.nameLab.text = [NSString stringWithFormat:@"Hi,%@",[YWTLoginManager obtainWithRealName]];
    }
    return _userCell;
}
-(YWTHomeMarkCell *)markCell{
    if (!_markCell) {
        _markCell = [[YWTHomeMarkCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MARKCELL"];
        _markCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _markCell;
}
-(YWTHomeModeCell *)preciseQueryCell{
    if (!_preciseQueryCell) {
        _preciseQueryCell = [[YWTHomeModeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PREISEQUERY"];
        _preciseQueryCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _preciseQueryCell.modeBgImageV.image = [UIImage imageChangeName:@"sy_pic_bg01"];
    }
    return _preciseQueryCell;
}
-(YWTHomeModeCell *)quickSearchCell{
    if (!_quickSearchCell) {
        _quickSearchCell = [[YWTHomeModeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QUICKSEARCH"];
        _quickSearchCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _quickSearchCell.modeImageV.image = [UIImage imageChangeName:@"sy_ico_02"];
        _quickSearchCell.modeBgImageV.image = [UIImage imageChangeName:@"sy_pic_bg02"];
        _quickSearchCell.modeTitleLab.text = @"快速查询";
        _quickSearchCell.modeSubtitleLab.text = @"人不在现场，只快速验证件";
    }
    return _quickSearchCell;
}
-(YWTHomeHistoryRecordCell *)historyRecordCell{
    if (!_historyRecordCell) {
        _historyRecordCell = [[YWTHomeHistoryRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RECORDCELL"];
        _historyRecordCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _historyRecordCell;
}
-(YWTUpdateView *)updateView{
    if (!_updateView) {
        _updateView = [[YWTUpdateView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-KSTabbarH)];
    }
    return _updateView;
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

// 精度获取   YES  快速查询  NO 精准查询
-(void) requestGetAccuracyIsQuick:(BOOL)isQuick{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [[YWTHttpManager sharedManager]postRequestUrl:HTTP_ATTAPPUSERGETACCURACY params:param waitView:self.view complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
        if (error) {
            [self.view showErrorWithTitle:@"请检查网络!" autoCloseTime:1];
            return;
        }
        if (![showdata isKindOfClass:[NSDictionary class]]) {
            [self.view showErrorWithTitle:@"数据返回结构错误!" autoCloseTime:1];
            return;
        }
        NSDictionary *data = (NSDictionary*)showdata[@"data"];
        // 1 高精度  2 低精度
        NSString *typeStr = [NSString stringWithFormat:@"%@",data[@"type"]];
        if (isQuick) {
            YWTBaseQueryController *queryVC = [[YWTBaseQueryController alloc]init];
            queryVC.viewType = showViewControllerQuickSearchType;
            queryVC.isAccurateBasic = [typeStr isEqualToString:@"1"] ? YES : NO;
            [self.navigationController pushViewController:queryVC animated:YES];
        }else{
            YWTBaseQueryController *queryVC = [[YWTBaseQueryController alloc]init];
            queryVC.viewType = showViewControllerSearchType;
            queryVC.isAccurateBasic = [typeStr isEqualToString:@"1"] ? YES : NO;
            [self.navigationController pushViewController:queryVC animated:YES];
        }
    }];
}


@end
