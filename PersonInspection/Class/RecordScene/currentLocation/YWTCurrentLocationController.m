//
//  YWTCurrentLocationController.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/16.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTCurrentLocationController.h"

#import "YWTCurrentLocationCell.h"


@interface YWTCurrentLocationController ()
<
UITableViewDelegate,
UITableViewDataSource,
BMKPoiSearchDelegate
>
@property (nonatomic,strong) UITableView *locationTableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) BMKPoiSearch *poiSearch;

@end

@implementation YWTCurrentLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    // 设置导航栏
    [self setNavi];

    [self.view addSubview:self.locationTableView];
    [self createSearchOption];
}
#pragma  mark ---------------- UITableViewDataSource --------------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataArr[section];
    return arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWTCurrentLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LOCATIONCELL" forIndexPath:indexPath];
    NSArray *arr = self.dataArr[indexPath.section];
    BMKPoiInfo *info = arr[indexPath.row];
    cell.poiInfo =  info;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KSIphonScreenH(65);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KSIphonScreenH(12))];
    headerView.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return KSIphonScreenH(12);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YWTCurrentLocationCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectBtn.selected = YES;
    if ([self.delegate respondsToSelector:@selector(selectLocationData:)]) {
        NSArray *arr = self.dataArr[indexPath.section];
        BMKPoiInfo *info = arr[indexPath.row];
        [self.delegate selectLocationData:info.address];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma  mark ---------------- 创建搜索POI  --------------------
-(void) createSearchOption{
    //初始化请求参数类BMKNearbySearchOption的实例
    BMKPOINearbySearchOption *nearbyOption = [[BMKPOINearbySearchOption alloc] init];
    //检索关键字，必选
    nearbyOption.keywords = @[@"启迪园"];
    //检索中心点的经纬度，必选
    nearbyOption.location = CLLocationCoordinate2DMake(self.mLoction.location.coordinate.latitude, self.mLoction.location.coordinate.longitude);
    //检索半径，单位是米。
    nearbyOption.radius = 1000;
    //是否严格限定召回结果在设置检索半径范围内。默认值为false。
    nearbyOption.isRadiusLimit = NO;
    //分页页码，默认为0，0代表第一页，1代表第二页，以此类推
    nearbyOption.pageIndex = 0;
    //单次召回POI数量，默认为10条记录，最大返回20条。
    nearbyOption.pageSize = 10;
    
    // 发起POI 搜索
    bool flag = [self.poiSearch poiSearchNearBy:nearbyOption];
    if (flag) {
       
    }else{
        
    }
}
#pragma mark - BMKPoiSearchDelegate  --------
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPOISearchResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    //BMKSearchErrorCode错误码，BMK_SEARCH_NO_ERROR：检索结果正常返回
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"检索结果返回成功：%@",poiResult.poiInfoList);
        NSMutableArray *arr = [NSMutableArray arrayWithArray:poiResult.poiInfoList];
        [self.dataArr addObject:arr];
        [self.locationTableView reloadData];
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD) {
        NSLog(@"检索词有歧义");
    } else {
        NSLog(@"其他检索结果错误码相关处理");
    }
}
#pragma  mark ----------------  设置导航栏--------------------
-(void) setNavi{
    [self.customNavBar wr_setBackgroundAlpha:1];
    self.customNavBar.title =@"当前位置";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_btn_back"]];
    WS(weakSelf);
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
#pragma  mark ----------------  get -------------------
-(UITableView *)locationTableView{
    if (!_locationTableView) {
        _locationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-KSTabbarH)style:UITableViewStyleGrouped];
        _locationTableView.delegate = self;
        _locationTableView.dataSource = self;
        _locationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_locationTableView registerClass:[YWTCurrentLocationCell class] forCellReuseIdentifier:@"LOCATIONCELL"];
    }
    return _locationTableView;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(BMKPoiSearch *)poiSearch{
    if (!_poiSearch) {
        _poiSearch = [[BMKPoiSearch alloc]init];
        _poiSearch.delegate = self;
    }
    return _poiSearch;
}
-(void)setMLoction:(BMKLocation *)mLoction{
    _mLoction = mLoction;
}


@end
