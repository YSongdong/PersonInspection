//
//  YWTRecordSceneDetailController.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/18.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTRecordSceneDetailController.h"

#import "YWTSaveSuccessController.h"

#import "YWTRecordPhotoCell.h"
#define PHOTOCELL @"YWTRecordPhotoCell"
#import "YWTDetailBaseCell.h"
#define DETAILBASE  @"YWTDetailBaseCell"
#import "YWTRecrodDetailCell.h"
#define RECRORDDETAIL  @"YWTRecrodDetailCell"
#import "YWTRecordDetailView.h"
#define DETAILVIEW  @"YWTRecordDetailView"

@interface YWTRecordSceneDetailController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic,strong) UICollectionView *detailCollection;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation YWTRecordSceneDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    //设置导航栏
    [self setNavi];
    
    [self.view addSubview:self.detailCollection];
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArr.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *arr = self.dataArr[section];
    return arr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YWTRecordPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PHOTOCELL forIndexPath:indexPath];
        NSMutableArray *arr = self.dataArr[indexPath.section];
        YWTAddRecordModel *model = arr[indexPath.row];
        if (self.idStr != nil) {
            cell.showModel = model;
        }else{
            cell.model = model;
        }
        cell.isHiddenDelBtn = YES;
        return cell;
    }else if(indexPath.section == 1){
        YWTDetailBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DETAILBASE forIndexPath:indexPath];
        NSArray *arr = self.dataArr[indexPath.section];
        NSDictionary *dict = arr[indexPath.row];
        cell.dict = dict;
        return cell;
    }else{
        YWTRecrodDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RECRORDDETAIL forIndexPath:indexPath];
        NSArray *arr = self.dataArr[indexPath.section];
        NSDictionary *dict = arr[indexPath.row];
        cell.detailLab.text = [NSString stringWithFormat:@"%@",dict[@"remark"]];
        return cell;
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake((KScreenW-KSIphonScreenW(40))/3, KSIphonScreenH(100));
    }else if(indexPath.section == 1){
        return CGSizeMake(KScreenW, KSIphonScreenH(240));
    }else{
        return CGSizeMake(KScreenW, KSIphonScreenH(80));
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
        return CGSizeMake(KScreenW, KSIphonScreenH(30));
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(KScreenW, 0);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YWTRecordDetailView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DETAILVIEW forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.detailLab.text = @"";
        }else if(indexPath.section == 1){
            headerView.detailLab.text = @"基础资料";
        }else{
            headerView.detailLab.text = @"现场描述";
        }
        return headerView;
    }else{
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FOOTER" forIndexPath:indexPath];
        return footerView;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSMutableArray *arr = self.dataArr[indexPath.section];
        NSMutableArray *items = [NSMutableArray array];
        for (int i=0; i < arr.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            YWTAddRecordModel *model = arr[i];
            if (self.idStr != nil) {
                KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:model.photoUrlStr]];
                [items addObject:item];
            }else{
                KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView image:model.photoImage];
                [items addObject:item];
            }
        }
        KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:indexPath.row];
        [browser showFromViewController:self];
    }
}
#pragma  mark ----------------  设置导航栏--------------------
-(void) setNavi{
    [self.customNavBar wr_setBackgroundAlpha:1];
    self.customNavBar.title =@"详情";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_btn_back"]];
    WS(weakSelf);
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    if (self.idStr != nil) {
        return;
    }
    [self.customNavBar wr_setRightButtonWithTitle:@"提交" titleColor:[UIColor colorNamlCommonTextColor]];
    self.customNavBar.rightButton.titleLabel.font = Font(16);
    self.customNavBar.onClickRightButton = ^{
        NSArray *imageArr = [weakSelf.dataArr firstObject];
        if (imageArr.count == 0) {
            [weakSelf requestRecordSceneDataImageUsr:@[]];
        }else{
           [weakSelf requestBusinessFilesData];
        }
    };
}
#pragma  mark ----------------  get  --------------------
-(UICollectionView *)detailCollection{
    if (!_detailCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing =  6;
        layout.minimumInteritemSpacing =0;
    
        _detailCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-KSTabbarH) collectionViewLayout:layout];
        _detailCollection.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
        _detailCollection.delegate = self;
        _detailCollection.dataSource = self;
        [_detailCollection registerClass:[YWTRecordPhotoCell class] forCellWithReuseIdentifier:PHOTOCELL];
        [_detailCollection registerClass:[YWTDetailBaseCell class] forCellWithReuseIdentifier:DETAILBASE];
        [_detailCollection registerClass:[YWTRecrodDetailCell class] forCellWithReuseIdentifier:RECRORDDETAIL];
        [_detailCollection registerClass:[YWTRecordDetailView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DETAILVIEW];
        [_detailCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FOOTER"];
    }
    return _detailCollection;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(void)setIdStr:(NSString *)idStr{
    _idStr = idStr;
    [self requestQuerySceneRecord];
}
-(void)setDataDictArr:(NSArray *)dataDictArr{
    _dataDictArr = dataDictArr;
    [self.dataArr removeAllObjects];
    
    [self.dataArr addObjectsFromArray:dataDictArr];
    
    [self.detailCollection reloadData];
}
-(void)setModel:(YWTCertificateModel *)model{
    _model = model;
}
#pragma  mark ---- 数据相关 -----
-(void) requestQuerySceneRecord{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = self.idStr;
    
    [[YWTHttpManager sharedManager] postRequestUrl:HTTP_ATTAPPBUSINESSQUERYSCENERECORD params:param waitView:self.view complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
        if (error) {
            [self.view showErrorWithTitle:error];
            return;
        }
        id data = showdata[@"data"];
        if (![data isKindOfClass:[NSDictionary class]]) {
            [self.view showErrorWithTitle:@"数据格式错误!"];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        [self.dataArr removeAllObjects];
        NSDictionary *dataDict = (NSDictionary*)data;
        
        NSMutableArray *listArr = [NSMutableArray array];
        NSArray *photoArr = dataDict[@"scene_url"];
        for (int i=0; i<photoArr.count; i++) {
            YWTAddRecordModel *model = [[YWTAddRecordModel alloc]init];
            model.isDel = NO;
            model.isCamera = NO;
            model.photoUrlStr = photoArr[i];
            [listArr addObject:model];
        }
        [self.dataArr addObject:listArr];
        
        NSMutableArray *userArr = [NSMutableArray array];
        [userArr addObject:dataDict];
        [self.dataArr addObject:userArr];
        
        NSMutableArray *markArr = [NSMutableArray array];
        [markArr addObject:dataDict];
        [self.dataArr addObject:markArr];
        
        [self.detailCollection reloadData];
        
        self.customNavBar.title = [NSString stringWithFormat:@"%@的详情",dataDict[@"name"]];
    }];
}
// 
-(void) requestBusinessFilesData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSArray *imageArr = [self.dataArr firstObject];
    NSMutableArray *mutableArr = [NSMutableArray array];
    for (YWTAddRecordModel *model in imageArr) {
        [mutableArr addObject:model.photoImage];
    }
    [[YWTHttpManager sharedManager] upLoadData:HTTP_ATTAPPBUSINESSFiles params:param andData:mutableArr andReceive:@"file" waitView:self.view complateHandle:^(id  _Nonnull showdata, NSDictionary * _Nonnull error) {
        if (error) {
            NSNumber *code = error[@"code"];
            if ([code integerValue] == 4001 ) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }else{
                NSString *msg = [NSString stringWithFormat:@"%@",error[@"message"]];
                [self.view showErrorWithTitle:msg];
            }
            return;
        }
        id data = showdata[@"data"];
        if (![data isKindOfClass:[NSArray class]]) {
            [self.view showErrorWithTitle:@"数据结构错误"];
            return;
        }
        NSArray *imageArr = (NSArray*)data;
        
        [self requestRecordSceneDataImageUsr:imageArr];
    }];
    
}
// 记录现场
-(void) requestRecordSceneDataImageUsr:(NSArray*)imageUrl{
    NSArray *markArr = self.dataArr[2];
    NSArray *userArr = self.dataArr[1];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:[userArr firstObject]];
    [param addEntriesFromDictionary:[markArr firstObject]];
    param[@"scene_url"] = imageUrl;
    param[@"record_id"] = self.model.record_id;
    param[@"certificate_name"] = self.model.certificate_name;
    param[@"certificate_num"] = self.model.certificate_num;
    param[@"constructor_id"] = self.model.constructor_id;
    param[@"certificate_url"] = self.model.certificate_url;
    param[@"face_url"] = self.model.face_url;
    [[YWTHttpManager sharedManager] postRequestUrl:HTTP_ATTAPPBUSINESSRECORDSCENE params:param waitView:self.view complateHandle:^(id  _Nonnull showdata, NSString * _Nonnull error) {
        if (error) {
            [self.view showErrorWithTitle:error];
            return;
        }
        
        NSString *idStr = showdata[@"data"];
        
        YWTSaveSuccessController *successVC = [[YWTSaveSuccessController alloc]init];
        successVC.idStr = idStr;
        [self.navigationController pushViewController:successVC animated:YES];
    }];
}


@end
