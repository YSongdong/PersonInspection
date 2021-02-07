//
//  YWTAddRecordSceneController.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/15.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTAddRecordSceneController.h"

#import "YWTCurrentLocationController.h"
#import "YWTRecordSceneDetailController.h"
#import "YWTAddRecordModel.h"

#import "YWTRecordPhotoCell.h"
#define PHOTOCELL @"YWTRecordPhotoCell"
#import "YWTAddBaseUserCell.h"
#define ADDBASEUSER   @"YWTAddBaseUserCell"
#import "YWTAddRecordAddressCell.h"
#define RECORDADDRESS  @"YWTAddRecordAddressCell"
#import "YWTAddRelateItemCell.h"
#define RELATEITEM     @"YWTAddRelateItemCell"
#import "YWTAddRecorDetailCell.h"
#define RECORDDETAIL  @"YWTAddRecorDetailCell"
#import "YWTRecordHeaderView.h"
#define RECORDHADERVIEW @"YWTRecordHeaderView"

@interface YWTAddRecordSceneController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
TZImagePickerControllerDelegate,
BMKLocationManagerDelegate,
YWTCurrentLocationControllerDelegate
>
@property (nonatomic,strong) CLLocationManager *locationManagerSystem;
@property (nonatomic,strong) UICollectionView *recordCollection;
@property (nonatomic,strong) NSMutableArray *dataArr;
// 组头是否隐藏   yes 隐藏 默认 NO
@property (nonatomic,assign) BOOL isHideTop;
// 定位
@property (nonatomic,strong) BMKLocationManager *locationManager;
//  定位地址
@property (nonatomic,strong) BMKLocation  *mLoction;
@end

@implementation YWTAddRecordSceneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    self.isHideTop =  NO;
    // 设置导航栏
    [self setNavi];
    // 定位权限弹窗不显示，原因是苹果要求调用请求。
    if (![self getUserLocationAuth]) {
        _locationManagerSystem = [[CLLocationManager alloc]init];
        [_locationManagerSystem requestWhenInUseAuthorization];
    }
    // 创建定位
    [self createBMKLocation];

    [self.view addSubview:self.recordCollection];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArr.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *arr = self.dataArr[section];
    if (section == 0) {
        if (arr.count == 10) {
            return 9;
        }else{
            return arr.count;
        }
    }else{
        return arr.count;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YWTRecordPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PHOTOCELL forIndexPath:indexPath];
        NSMutableArray *arr = self.dataArr[indexPath.section];
        YWTAddRecordModel *model = arr[indexPath.row];
        cell.model = model;
        WS(weakSelf);
        // 点击删除
        cell.selectCellDel = ^{
            // 移除数据源
            [arr removeObjectAtIndex:indexPath.row];
            // 贴换数据源
            [weakSelf.dataArr replaceObjectAtIndex:indexPath.section withObject:arr];
            // 刷新UI
            [weakSelf.recordCollection deleteItemsAtIndexPaths:@[indexPath]];
        };
        return cell;
    }else{
        WS(weakSelf);
         if(indexPath.row == 3){
            YWTAddRecordAddressCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RECORDADDRESS forIndexPath:indexPath];
            NSMutableArray *arr = self.dataArr[indexPath.section];
            YWTAddRecordModel *model = arr[indexPath.row];
            cell.model = model;
            return cell;
        }else if(indexPath.row == 4){
            YWTAddRelateItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RELATEITEM forIndexPath:indexPath];
            cell.baseTitleLab.textColor = [UIColor colorNamlCommonTextColor];
            NSMutableArray *arr = self.dataArr[indexPath.section];
            YWTAddRecordModel *model = arr[indexPath.row];
            cell.model = model;
            // 点击完成
            cell.selectDone = ^(YWTAddRecordModel * _Nonnull model) {
                NSMutableArray *arr = self.dataArr[indexPath.section];
                // 贴换数据源
                [arr replaceObjectAtIndex:indexPath.row withObject:model];
                [weakSelf.dataArr replaceObjectAtIndex:indexPath.section withObject:arr];
            };
            return cell;
        }else if(indexPath.row == 5){
            YWTAddRecorDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RECORDDETAIL forIndexPath:indexPath];
            NSMutableArray *arr = self.dataArr[indexPath.section];
            YWTAddRecordModel *model = arr[indexPath.row];
            cell.model = model;
            // 点击完成
            cell.selectDetailDone  = ^(YWTAddRecordModel * _Nonnull model) {
                NSMutableArray *arr = self.dataArr[indexPath.section];
                // 贴换数据源
                [arr replaceObjectAtIndex:indexPath.row withObject:model];
                
                [weakSelf.dataArr replaceObjectAtIndex:indexPath.section withObject:arr];
            };
            return cell;
        }else if(indexPath.row == 2){
            YWTAddRelateItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RELATEITEM forIndexPath:indexPath];
            cell.itmeTextF.enabled = NO;
            NSMutableArray *arr = self.dataArr[indexPath.section];
            YWTAddRecordModel *model = arr[indexPath.row];
            cell.model = model;
            // 点击完成
            cell.selectDone = ^(YWTAddRecordModel * _Nonnull model) {
                NSMutableArray *arr = self.dataArr[indexPath.section];
                // 贴换数据源
                [arr replaceObjectAtIndex:indexPath.row withObject:model];
                [weakSelf.dataArr replaceObjectAtIndex:indexPath.section withObject:arr];
            };
            return cell;
        }else {
            YWTAddBaseUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ADDBASEUSER forIndexPath:indexPath];
            NSMutableArray *arr = self.dataArr[indexPath.section];
            YWTAddRecordModel *model = arr[indexPath.row];
            cell.model = model;
            return cell;
        }
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake((KScreenW-KSIphonScreenW(40))/3, KSIphonScreenH(100));
    }else{
        if (indexPath.row == 5){
            return CGSizeMake(KScreenW, KSIphonScreenH(160));
        }else{
            return CGSizeMake(KScreenW, KSIphonScreenH(60));
        }
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(12, 12, 12, 12);
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(KScreenW, 0);
    }else{
        if (self.isHideTop) {
            return CGSizeMake(KScreenW, 0);
        }else{
           return CGSizeMake(KScreenW, KSIphonScreenH(30));
        }
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(KScreenW, 0);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YWTRecordHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:RECORDHADERVIEW forIndexPath:indexPath];
        WS(weakSelf);
        // 点击组头隐藏
        headerView.selectDelBtn = ^{
            weakSelf.isHideTop = YES;
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
            [weakSelf.recordCollection reloadSections:indexSet];
        };
        return headerView;
    }else{
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FOOTER" forIndexPath:indexPath];
        return footerView;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSMutableArray *arr = self.dataArr[indexPath.section];
        YWTAddRecordModel *model = arr[indexPath.row];
        if (model.isCamera) {
            NSInteger index = 10-arr.count;
            if (index != 0 ) {
                [self createTZImagePickPage:index];
            }else{
                [self.view showErrorWithTitle:@"最多只能上传9张"];
            }
        }else{
            NSMutableArray *items = [NSMutableArray array];
            for (int i=0; i < arr.count -1; i++) {
                UIImageView *imageView = [[UIImageView alloc]init];
                YWTAddRecordModel *model = arr[i];
                KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView image:model.photoImage];
                [items addObject:item];
            }
            KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:indexPath.row];
            [browser showFromViewController:self];
        }
    }else{
        if (indexPath.row == 3) {
            YWTCurrentLocationController *locationVC = [[YWTCurrentLocationController alloc]init];
            locationVC.mLoction = self.mLoction;
            locationVC.delegate = self;
            [self.navigationController pushViewController:locationVC animated:YES];
        }
    }
}
#pragma mark -----  YWTCurrentLocationControllerDelegate ----
-(void) selectLocationData:(NSString*)locationStr{
    NSMutableArray *userArr = self.dataArr[1];
    YWTAddRecordModel *model = userArr[3];
    model.subTitleStr = locationStr;
    
    [userArr replaceObjectAtIndex:3 withObject:model];
    [self.dataArr replaceObjectAtIndex:1 withObject:userArr];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:1];
    [self.recordCollection reloadItemsAtIndexPaths:@[indexPath]];
}
// 创建多图选择
-(void) createTZImagePickPage:(NSInteger)index{
    TZImagePickerController *imagePickVC = [[TZImagePickerController alloc]initWithMaxImagesCount:index delegate:self];
    imagePickVC.iconThemeColor = [UIColor colorBlueTextColor];
    imagePickVC.showPhotoCannotSelectLayer = YES;
    imagePickVC.allowPickingVideo = NO;
    // 是否允许显示图片
    imagePickVC.allowPickingImage = YES;
    imagePickVC.barItemTextColor = [UIColor colorBlueTextColor];
    imagePickVC.naviBgColor = [UIColor colorTextWhiteColor];
    imagePickVC.oKButtonTitleColorNormal = [UIColor colorBlueTextColor];
    imagePickVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickVC animated:YES completion:nil];
}
#pragma mark --- TZImagePickerControllerDelegate --------
// 多图选择
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    
    NSMutableArray *imageArr = self.dataArr[0];
    
    for (int i=0; i<photos.count; i++) {
        // 计算超出最多图片数
        if (imageArr.count >= 10) {
           
            [self.dataArr replaceObjectAtIndex:0 withObject:imageArr];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
            [self.recordCollection reloadSections:indexSet];
            
            //
            [self.view showErrorWithTitle:@"已超出最多图片数" autoCloseTime:1];
            return;
        }
        // 取出照片
        UIImage *imagePhoto = photos[i];
        
        YWTAddRecordModel *photoModel = [[YWTAddRecordModel alloc]init];
        photoModel.isCamera = NO;
        photoModel.isDel =  YES;
        photoModel.photoImage = imagePhoto;
        [imageArr insertObject:photoModel atIndex:0];
    }
    [self.dataArr replaceObjectAtIndex:0 withObject:imageArr];
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.recordCollection reloadSections:indexSet];
}
#pragma  mark ----------------  创建百度定位--------------------
-(void)createBMKLocation{
    //初始化实例
    _locationManager = [[BMKLocationManager alloc] init];
    //设置delegate
    _locationManager.delegate = self;
    //设置返回位置的坐标系类型
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置应用位置类型
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    //设置是否自动停止位置更新
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    //设置位置获取超时时间
    _locationManager.locationTimeout = 10;
    //设置获取地址信息超时时间
    _locationManager.reGeocodeTimeout = 10;
    [_locationManager setLocatingWithReGeocode:YES];
   
    [_locationManager startUpdatingLocation];
}
//   -------------------  BMKLocationManagerDelegate ----
-(void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error{
    if (error)
    {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    } if (location) {
        //得到定位信息，添加annotation
        
        self.mLoction = location;
        // 定位地址
        NSString *addressStr;
        if ([location.rgcData.province isEqualToString:location.rgcData.city]) {
            addressStr = [NSString stringWithFormat:@"%@%@%@",location.rgcData.province,location.rgcData.street,location.rgcData.locationDescribe];
        }else{
             addressStr = [NSString stringWithFormat:@"%@%@%@%@",location.rgcData.province,location.rgcData.city,location.rgcData.street,location.rgcData.locationDescribe];
        }
        NSMutableArray *userArr = self.dataArr[1];
        YWTAddRecordModel *model = userArr[3];
        model.subTitleStr = addressStr;
        
        [userArr replaceObjectAtIndex:3 withObject:model];
        [self.dataArr replaceObjectAtIndex:1 withObject:userArr];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:1];
        [self.recordCollection reloadItemsAtIndexPaths:@[indexPath]];
    }
}
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusDenied:{
            // 类方法，判断是否开启定位服务
            if ([CLLocationManager locationServicesEnabled]) {
                UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:@"未开启定位权限" message:@"请去系统设置里开启“考勤管理系统”的定位权限" preferredStyle:UIAlertControllerStyleAlert];
                [alterVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.000000) {
                        //跳转到定位权限页面
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                            [[UIApplication sharedApplication] openURL:url];
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                    }else {
                        //跳转到定位开关界面
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                            [[UIApplication sharedApplication] openURL:url];
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                    }
                }]];
                [alterVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }]];
                [self presentViewController:alterVC animated:YES completion:nil];
            }
            break;
        }
        default:
            break;
    }
}
- (BOOL)getUserLocationAuth {
    BOOL result = NO;
    switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusNotDetermined:
            break;
            case kCLAuthorizationStatusRestricted:
            break;
            case kCLAuthorizationStatusDenied:
            break;
            case kCLAuthorizationStatusAuthorizedAlways:
            result = YES;
            break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            result = YES;
            break;
            
        default:
            break;
    }
    return result;
}
#pragma mark ---- 判断用户手机授权定位服务 ------
-(void) createLocationAuthorizationServer{
    BOOL enable = [CLLocationManager locationServicesEnabled];
    NSInteger state = [CLLocationManager authorizationStatus];
    if (!enable || 2 > state) {
        if (8 <= [[UIDevice currentDevice].systemVersion floatValue]) {
            NSLog(@"系统位置权限授权弹窗");
            // 系统位置权限授权弹窗
            CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
            [locationManager requestAlwaysAuthorization];
            [locationManager requestWhenInUseAuthorization];
        }
    }
}
#pragma mark  --- 下一步按钮点击方法 ------
-(void)getNextStep{
    [self.view endEditing:YES];
    
    // 获取用户信息
    NSArray * userArr = self.dataArr[1];
    YWTAddRecordModel *nbnormModel = userArr[2];
//    if (nbnormModel.subTitleStr.length == 0) {
//        [self.view showErrorWithTitle:@"请输入异常问题"];
//        return;
//    }
    YWTAddRecordModel *addressModel = userArr[3];
//    if (addressModel.subTitleStr.length == 0 ) {
//        [self.view showErrorWithTitle:@"请选择当前位置"];
//        return;
//    }
    
    YWTAddRecordModel *projectModel = userArr[4];
//    if (projectModel.subTitleStr.length == 0 ) {
//        [self.view showErrorWithTitle:@"请输入相关项目"];
//        return;
//    }
    
    YWTAddRecordModel *markModel = userArr[5];

    NSMutableArray *dataDictArr = [NSMutableArray array];
    NSMutableArray *imageArr =[NSMutableArray arrayWithArray:[self.dataArr firstObject]];
    [imageArr removeLastObject];
    [dataDictArr addObject:imageArr];
    
    NSMutableArray *mutableUsreArr = [NSMutableArray array];
    NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
    userDict[@"name"] = self.model.name;
    userDict[@"certificate_num"] = self.model.certificate_num;
    userDict[@"problem"] =nbnormModel.subTitleStr;
    userDict[@"location"] =addressModel.subTitleStr;
    userDict[@"project"] =projectModel.subTitleStr;
    [mutableUsreArr addObject:userDict];
    [dataDictArr addObject:mutableUsreArr];
    
    NSMutableArray *markArr = [NSMutableArray array];
    NSMutableDictionary *markDict = [NSMutableDictionary dictionary];
    markDict[@"remark"] = markModel.subTitleStr;
    [markArr addObject:markDict];
    [dataDictArr addObject:markArr];
    
    YWTRecordSceneDetailController *detailVC = [[YWTRecordSceneDetailController alloc]init];
    detailVC.model = self.model;
    detailVC.dataDictArr = dataDictArr;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma  mark ----------------  设置导航栏--------------------
-(void) setNavi{
    [self.customNavBar wr_setBackgroundAlpha:1];
    self.customNavBar.title =@"记录现场";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_btn_back"]];
    WS(weakSelf);
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.customNavBar wr_setRightButtonWithTitle:@"提交" titleColor:[UIColor orangeColor]];
    [self.customNavBar.rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    self.customNavBar.rightButton.frame = CGRectMake(KScreenW-60, KSStatusHeight+7, 50, 30);
    self.customNavBar.rightButton.titleLabel.font = Font(16);
    [self.customNavBar.rightButton setTitleColor:[UIColor colorNamlCommonTextColor] forState:UIControlStateNormal];
    self.customNavBar.onClickRightButton = ^{
        [weakSelf getNextStep];
    };
}
-(void)touchTapleView{
    [self.view endEditing:YES];
}
#pragma  mark ----------------  get 方法 --------------------
-(UICollectionView *)recordCollection{
    if (!_recordCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing =  6;
        layout.minimumInteritemSpacing =0;
    
        _recordCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-KSTabbarH) collectionViewLayout:layout];
        _recordCollection.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
        _recordCollection.delegate = self;
        _recordCollection.dataSource = self;
        [_recordCollection registerClass:[YWTRecordPhotoCell class] forCellWithReuseIdentifier:PHOTOCELL];
        [_recordCollection registerClass:[YWTAddBaseUserCell class] forCellWithReuseIdentifier:ADDBASEUSER];
        [_recordCollection registerClass:[YWTAddRecordAddressCell class] forCellWithReuseIdentifier:RECORDADDRESS];
        [_recordCollection registerClass:[YWTAddRelateItemCell class] forCellWithReuseIdentifier:RELATEITEM];
        [_recordCollection registerClass:[YWTAddRecorDetailCell class] forCellWithReuseIdentifier:RECORDDETAIL];
        [_recordCollection registerClass:[YWTRecordHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:RECORDHADERVIEW];
        [_recordCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FOOTER"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTapleView)];
        tap.cancelsTouchesInView = NO;
        [_recordCollection addGestureRecognizer:tap];
    }
    return _recordCollection;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        NSMutableArray *imageArr = [NSMutableArray array];
        
        if (self.model.faceImage != nil) {
            YWTAddRecordModel *imageModel = [[YWTAddRecordModel alloc]init];
            imageModel.photoImage = self.model.faceImage;
            imageModel.isDel =  NO;
            imageModel.isCamera = NO;
            [imageArr addObject:imageModel];
        }
        
        if (self.model.certificateImage != nil) {
            YWTAddRecordModel *imageModel = [[YWTAddRecordModel alloc]init];
            imageModel.photoImage = self.model.certificateImage;
            imageModel.isDel =  NO;
            imageModel.isCamera = NO;
            [imageArr addObject:imageModel];
        }
        YWTAddRecordModel *imageModel = [[YWTAddRecordModel alloc]init];
        imageModel.photoImage = [UIImage imageNamed:@"result_btn_add"];
        imageModel.isDel =  NO;
        imageModel.isCamera = YES;
        [imageArr addObject:imageModel];
        
        [_dataArr addObject:imageArr];
        NSMutableArray *infoArr = [NSMutableArray array];
        YWTAddRecordModel *idModel = [[YWTAddRecordModel alloc]init];
        idModel.titleStr = @"证件号码";
        idModel.subTitleStr =  self.model.certificate_num;
        [infoArr addObject:idModel];
        YWTAddRecordModel *nameModel = [[YWTAddRecordModel alloc]init];
        nameModel.titleStr = @"姓名";
        nameModel.subTitleStr =  self.model.name;
        [infoArr addObject:nameModel];
        YWTAddRecordModel *abnormalModel = [[YWTAddRecordModel alloc]init];
        abnormalModel.titleStr = @"异常问题";
        abnormalModel.subTitleStr =  [self.model.errorMsg isEqualToString:@""] ? @"其他" : self.model.errorMsg;
        [infoArr addObject:abnormalModel];
        YWTAddRecordModel *addressModel = [[YWTAddRecordModel alloc]init];
        addressModel.titleStr = @"当前位置";
        addressModel.subTitleStr =  @"";
        [infoArr addObject:addressModel];
        YWTAddRecordModel *projectModel = [[YWTAddRecordModel alloc]init];
        projectModel.titleStr = @"相关项目";
        projectModel.subTitleStr =  @"";
        [infoArr addObject:projectModel];
        YWTAddRecordModel *detailModel = [[YWTAddRecordModel alloc]init];
        detailModel.titleStr = @"";
        detailModel.subTitleStr =  @"";
        [infoArr addObject:detailModel];
        [_dataArr addObject:infoArr];
    }
    return _dataArr;
}
-(void)setModel:(YWTCertificateModel *)model{
    _model = model;
}



@end
