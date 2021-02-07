//
//  YWTResultListController.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/15.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTResultListController.h"

#import "YWTSearchResultController.h"
#import "YWTRecordSceneDetailController.h"

#import "YWTResultSiftView.h"
#import "YWTHeaderSearchView.h"
#import "YWTListBlankPageView.h"
#import "YWTNewRsultListCell.h"

#define YWTRSULTLIST_CELL @"YWTNewRsultListCell"

@interface YWTResultListController ()
<
UITableViewDelegate,
UITableViewDataSource,
YWTHeaderSearchViewDelegate,
YWTResultSiftViewDelegate
>
// 搜索view
@property (nonatomic,strong) YWTHeaderSearchView *headerSearchView;
// 筛选
@property (nonatomic,strong) YWTResultSiftView *siftView;

@property (nonatomic,strong) YWTListBlankPageView *blankPageView;

@property (nonatomic,strong) UITableView *listTableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSString *keywordStr;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) NSInteger time;
@end

@implementation YWTResultListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    //设置导航栏
    [self setNavi];
    self.page = 1;
    self.status = 0;
    self.time = 0;
    self.keywordStr = @"";
    
    [self.view addSubview:self.headerSearchView];
    [self.view addSubview:self.listTableView];
//    [self.view addSubview:self.blankPageView];
   
    [self requestRecordList];
}
#pragma  mark ---------------- UITableViewDataSource --------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWTNewRsultListCell *cell = [tableView dequeueReusableCellWithIdentifier:YWTRSULTLIST_CELL forIndexPath:indexPath];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.dict = dict;
    WS(weakSelf);
    cell.selectPic = ^(NSInteger tag) {
        [weakSelf openBigPicDict:dict selectTap:tag];
    };
    // 点击cell
    cell.selectCell = ^{
        // 状态:1-正常,2-异常,3-过期
        NSString *statuStr = [NSString stringWithFormat:@"%@",dict[@"status"]];
        if ([statuStr isEqualToString:@"1"] || [statuStr isEqualToString:@"3"]) {
            YWTSearchResultController *resultVC = [[YWTSearchResultController alloc]init];
            resultVC.idStr = [NSString stringWithFormat:@"%@",dict[@"id"]];
            resultVC.isRecord = YES;
            [weakSelf.navigationController pushViewController:resultVC animated:YES];
        }else if([statuStr isEqualToString:@"2"]){
            YWTRecordSceneDetailController *sceneDetailVC = [[YWTRecordSceneDetailController alloc]init];
            sceneDetailVC.idStr = [NSString stringWithFormat:@"%@",dict[@"id"]];
            [weakSelf.navigationController pushViewController:sceneDetailVC animated:YES];
        }
    };
    // 解绑按钮
    cell.selectUnbundBtn = ^{
        [weakSelf requestClearBusinessDict:dict removeIndex:indexPath];
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArr[indexPath.row];
    if ([dict[@"face_url"] isEqualToString:@""] && [dict[@"certificate_url"] isEqualToString:@""]) {
        return KSIphonScreenH(120);
    }
    return KSIphonScreenH(180);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(void) openBigPicDict:(NSDictionary*)dict selectTap:(NSInteger)tap{
    NSMutableArray *items = [NSMutableArray array];
    if (![dict[@"face_url"] isEqualToString:@""]) {
        YBIBImageData *data = [YBIBImageData new];
        data.imageURL = dict[@"face_url"];
        data.allowSaveToPhotoAlbum = NO;
        [items addObject:data];
    }
    if (![dict[@"certificate_url"] isEqualToString:@""]) {
        YBIBImageData *data = [YBIBImageData new];
        data.imageURL = dict[@"certificate_url"];
        data.allowSaveToPhotoAlbum = NO;
        [items addObject:data];
    }
    NSInteger index = 0;
    if (![dict[@"face_url"] isEqualToString:@""] && ![dict[@"certificate_url"] isEqualToString:@""]) {
        index = tap;
    }
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = items;
    browser.currentPage = index;
    browser.defaultToolViewHandler.topView.operationButton.hidden = YES;
    [browser showToView:self.view];
}

#pragma  mark ----------------  YWTHeaderSearchViewDelegate--------------------
-(void) selectSearchBtn:(NSString*)searchStr{
    self.keywordStr = searchStr;
    self.page = 1;
    self.status = 0;
    self.time = 0;
    [self requestRecordList];
}
#pragma mark --------- YWTResultSiftViewDelegate ---
// 点击确定按钮
-(void) selectSubmitBtnTagIdStr:(NSString *)tagIdStr{
    [self.siftView removeFromSuperview];
    NSArray *arr = [tagIdStr componentsSeparatedByString:@","];
    self.status = [[arr firstObject] integerValue];
    self.time = [[arr lastObject] integerValue] ;
    self.keywordStr = @"";
    self.page = 1;
    [self requestRecordList];
}
#pragma  mark ----------------  设置导航栏--------------------
-(void) setNavi{
    [self.customNavBar wr_setBackgroundAlpha:1];
    self.customNavBar.title =@"查询记录";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_btn_back"]];
    WS(weakSelf);
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.customNavBar wr_setRightButtonWithTitle:@"筛选" titleColor:[UIColor colorNamlCommonTextColor]];
    self.customNavBar.rightButton.titleLabel.font = Font(16);
    self.customNavBar.onClickRightButton = ^{
        [weakSelf.view addSubview:weakSelf.siftView];
    };
}
#pragma  mark ----------------  get 方法  --------------------
-(YWTHeaderSearchView *)headerSearchView{
    if (!_headerSearchView) {
        _headerSearchView = [[YWTHeaderSearchView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KSIphonScreenH(55))];
        _headerSearchView.delegate = self;
    }
    return _headerSearchView;
}
-(YWTListBlankPageView *)blankPageView{
    if (!_blankPageView) {
        _blankPageView = [[YWTListBlankPageView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-KSNaviTopHeight-KSIphonScreenH(55)-KSTabbarH)];
    }
    return _blankPageView;
}
-(UITableView *)listTableView{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight+KSIphonScreenH(55), KScreenW, KScreenH-KSNaviTopHeight-KSIphonScreenH(55)-KSTabbarH)];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
        [_listTableView registerClass:[YWTNewRsultListCell class] forCellReuseIdentifier:YWTRSULTLIST_CELL];
       
        if (@available(iOS 11.0, *)) {
            self.listTableView.estimatedRowHeight = 0;
            self.listTableView.estimatedSectionFooterHeight = 0;
            self.listTableView.estimatedSectionHeaderHeight = 0 ;
            self.listTableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        [self.listTableView addSubview:self.blankPageView];
        
        __weak typeof(self) weakSelf = self;
        // 刷新
        [self.listTableView bindGlobalStyleForHeadRefreshHandler:^{
            weakSelf.page = 1;
            [weakSelf requestRecordList];
        }];

        [self.listTableView bindGlobalStyleForFootRefreshHandler:^{
            weakSelf.page ++;
            [weakSelf requestRecordList];
        }];
    }
    return _listTableView;
}
-(YWTResultSiftView *)siftView{
    if (!_siftView) {
        _siftView = [[YWTResultSiftView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-KSTabbarH)];
        _siftView.delegate = self;
    }
    return _siftView;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
#pragma mark ----  数据相关 -----
-(void) requestRecordList{
    NSMutableDictionary  *param = [NSMutableDictionary dictionary];
    param[@"keyword"] = self.keywordStr;
    param[@"page"]  = [NSNumber numberWithInteger:self.page];
    param[@"status"] = [NSNumber numberWithInteger:self.status];
    param[@"size"] = [NSNumber numberWithInteger:20];
    param[@"time"] = [NSNumber numberWithInteger:self.time];
    [[YWTHttpManager sharedManager] postRequestUrl:HTTP_ATTAPPBUSINESSRECORDLIST params:param waitView:self.view complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
        // 结束刷新控件
        [self.listTableView.headRefreshControl endRefreshing];
        [self.listTableView.footRefreshControl endRefreshing];
        if (error) {
            [self.view showErrorWithTitle:error];
            return;
        }
        id data =showdata[@"data"];
        if (![data isKindOfClass:[NSArray class]]) {
            return;
        }
        if (self.page == 1) {
            [self.dataArr removeAllObjects];
        }
        
        NSArray *dataArr = (NSArray*)data;
        [self.dataArr addObjectsFromArray:dataArr];
    
        [self.listTableView reloadData];
        
        // 添加空白页
        if (self.dataArr.count == 0) {
            self.blankPageView.hidden = NO;
        }else{
            self.blankPageView.hidden = YES;
        }
    }];
}
// 清除解绑
-(void) requestClearBusinessDict:(NSDictionary*)dict removeIndex:(NSIndexPath*)indexPath{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"certificate_num"] = dict[@"certificate_num"];
    param[@"record_id"] = dict[@"id"];
    [[YWTHttpManager sharedManager]postRequestUrl:HTTP_ATTAPPBUSINESSCLEART params:param waitView:self.view complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
        if (error) {
            [self.view showErrorWithTitle:error];
            return;
        }
        // 移除数据
        [self.dataArr removeObjectAtIndex:indexPath.row];
        
        [self.listTableView reloadData];
    }];
}





@end
