//
//  YWTResultSiftView.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/15.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTResultSiftView.h"

#import "SiftModuleCollectionViewCell.h"
#define SIFTMOUDLECOLLECTIONVIEW_CELL @"SiftModuleCollectionViewCell"
#import "YWTResultSiftReusableView.h"
#define YWTRESULTSIFTREUSABLEVIEW  @"YWTResultSiftReusableView"
#define SIFTMODULEFOOTERREUSABLEVIEW  @"FOOTER"

@interface YWTResultSiftView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic,strong) UICollectionView *siftCollect;
@property (nonatomic,strong) NSMutableArray *dataArr;
//选中IndexPath
@property (nonatomic,strong) NSMutableArray *selectIndexPathArr;
@end


@implementation YWTResultSiftView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArr.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDictionary *dict = self.dataArr[section];
    NSArray *arr = dict[@"children"];
    return arr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SiftModuleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SIFTMOUDLECOLLECTIONVIEW_CELL forIndexPath:indexPath];
    NSDictionary *dict = self.dataArr[indexPath.section];
    NSArray *arr = dict[@"children"];
    cell.dict = arr[indexPath.row];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KScreenW-KSIphonScreenW(70))/4, KSIphonScreenH(33));
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(KScreenW, KSIphonScreenH(33));
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(KScreenW, 1);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YWTResultSiftReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:YWTRESULTSIFTREUSABLEVIEW forIndexPath:indexPath];
        headerView.dict =self.dataArr[indexPath.section];
        return headerView;
    }else{
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:SIFTMODULEFOOTERREUSABLEVIEW forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor colorLineCommonTextColor];
        return footerView;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *statuIndexPath = self.selectIndexPathArr[indexPath.section];
    NSMutableDictionary *mutableDict = self.dataArr[indexPath.section];
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:mutableDict[@"children"]];
    
    //把上次选中还原
    NSMutableDictionary *oldDict = [NSMutableDictionary dictionaryWithDictionary:mutableArr[statuIndexPath.row]];
    oldDict[@"isSelect"] = @"2";
    //贴换
    [mutableArr replaceObjectAtIndex:statuIndexPath.row withObject:oldDict];
    
    //把当前变为选中状态
    NSMutableDictionary *nowDict = [NSMutableDictionary dictionaryWithDictionary:mutableArr[indexPath.row]];
    nowDict[@"isSelect"] = @"1";
    //贴换
    [mutableArr replaceObjectAtIndex:indexPath.row withObject:nowDict];
    
    mutableDict[@"children"] = mutableArr.copy;
    [self.dataArr replaceObjectAtIndex:indexPath.section withObject:mutableDict];
    
    statuIndexPath = indexPath;
    [self.selectIndexPathArr replaceObjectAtIndex:indexPath.section withObject:statuIndexPath];
    
    //刷新
    [self.siftCollect reloadData];
  
}
#pragma mark ----  按钮点击方法 ---------
// 重置
-(void)selectReplaceAction:(UIButton*)sender{
    for (int i=0; i<self.dataArr.count; i++) {
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[i]];
        NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:mutableDict[@"children"]];
        for (int j=0; j<mutableArr.count; j++) {
            if (j == 0) {
                NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:mutableArr[j]];
                mutableDict[@"isSelect"] = @"1";
                //贴换
                [mutableArr replaceObjectAtIndex:j withObject:mutableDict];
            }else{
                NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:mutableArr[j]];
                mutableDict[@"isSelect"] = @"2";
                //贴换
                [mutableArr replaceObjectAtIndex:j withObject:mutableDict];
            }
        }
        mutableDict[@"children"] = mutableArr.copy;
        //贴换
        [self.dataArr replaceObjectAtIndex:i withObject:mutableDict];
    }
    [self.selectIndexPathArr removeAllObjects];
    for (int i=0; i<self.dataArr.count; i++) {
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:i];
        [self.selectIndexPathArr addObject:indexPath];
    }
    [self.siftCollect reloadData];
    //筛选
    if ([self.delegate respondsToSelector:@selector(selectSubmitBtnTagIdStr:)]) {
        [self.delegate selectSubmitBtnTagIdStr:@"0,0"];
    }
}
// 确认
-(void)selectTrueAction:(UIButton*)sender{
    NSMutableString *tagIdStr = [NSMutableString string];
    for (int i=0; i< self.selectIndexPathArr.count; i++) {
        NSIndexPath *indexPath = self.selectIndexPathArr[i];
        NSDictionary *dict = self.dataArr[indexPath.section];
        NSArray *arr = dict[@"children"];
        NSDictionary *childrenDict = arr[indexPath.row];
        [tagIdStr appendString:[NSString stringWithFormat:@"%@",childrenDict[@"id"]]];
        if (i != self.selectIndexPathArr.count-1) {
            [tagIdStr appendString:@","];
        }
    }
    //筛选
    if ([self.delegate respondsToSelector:@selector(selectSubmitBtnTagIdStr:)]) {
        [self.delegate selectSubmitBtnTagIdStr:tagIdStr];
    }
}
//
-(void) selectTap{
    [self removeFromSuperview];
}
-(void) createView{
    WS(weakSelf);
    UIView *bigBgView = [[UIView alloc]init];
    [self addSubview:bigBgView];
    bigBgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.65];
    [bigBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTap)];
    [bigBgView addGestureRecognizer:tap];
    
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.height.equalTo(@(KSIphonScreenH(240)));
    }];
    
    UIView *bottomView = [[UIView alloc]init];
    [bgView addSubview:bottomView];
    bottomView.backgroundColor  = [UIColor colorViewBackGrounpWhiteColor];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(-KSTabbarH);
        make.height.equalTo(@(KSIphonScreenH(56)));
    }];
    
    UIButton *replaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:replaceBtn];
    [replaceBtn setTitle:@"重置" forState:UIControlStateNormal];
    [replaceBtn setTitleColor:[UIColor colorNamlCommonTextColor] forState:UIControlStateNormal];
    replaceBtn.titleLabel.font = Font(14);
    replaceBtn.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorWithHexString:@"#263143"] normalCorlor:[UIColor colorSiftTextColor]];
    [replaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(KSIphonScreenW(12));
        make.top.equalTo(bottomView).offset(KSIphonScreenH(8));
        make.bottom.equalTo(bottomView).offset(-KSIphonScreenH(8));
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    replaceBtn.layer.cornerRadius = 10/2;
    replaceBtn.layer.masksToBounds = YES;
    [replaceBtn addTarget:self action:@selector(selectReplaceAction:) forControlEvents:UIControlEventTouchUpInside];
  
    
    UIButton *trueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:trueBtn];
    [trueBtn setTitle:@"确认" forState:UIControlStateNormal];
    [trueBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    trueBtn.titleLabel.font = Font(14);
    trueBtn.backgroundColor = [UIColor colorBlueTextColor];
    [trueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(replaceBtn.mas_right).offset(10);
        make.right.equalTo(bottomView).offset(-12);
        make.width.height.equalTo(replaceBtn);
        make.centerY.equalTo(replaceBtn.mas_centerY);
    }];
    trueBtn.layer.cornerRadius = 3;
    trueBtn.layer.masksToBounds = YES;
    [trueBtn addTarget:self action:@selector(selectTrueAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = KSIphonScreenW(10);
    layout.minimumInteritemSpacing = KSIphonScreenH(10);
    layout.sectionInset = UIEdgeInsetsMake(KSIphonScreenH(5), KSIphonScreenW(12), KSIphonScreenH(15), KSIphonScreenW(12));
    self.siftCollect = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [bgView addSubview:self.siftCollect];
    self.siftCollect.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    [self.siftCollect mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(bgView);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    self.siftCollect.delegate = self;
    self.siftCollect.dataSource = self;
    [self.siftCollect registerNib:[UINib nibWithNibName:SIFTMOUDLECOLLECTIONVIEW_CELL bundle:nil] forCellWithReuseIdentifier:SIFTMOUDLECOLLECTIONVIEW_CELL];
    [self.siftCollect registerClass:[YWTResultSiftReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:YWTRESULTSIFTREUSABLEVIEW];
    [self.siftCollect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:SIFTMODULEFOOTERREUSABLEVIEW];
}
#pragma mark ----  get方法 ---------
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        NSMutableDictionary *statuDict = [NSMutableDictionary dictionary];
        statuDict[@"title"] = @"按状态:";
        NSArray *statuArr = @[@"全部",@"正常",@"异常"];
        NSMutableArray *mutableStatuArr = [NSMutableArray array];
        for (int i=0; i<statuArr.count; i++) {
            NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
            contentDict[@"title"] = statuArr[i];
            contentDict[@"isSelect"] = i == 0 ? @"1" : @"2";
            contentDict[@"id"] = [NSNumber numberWithInt:i];
            [mutableStatuArr addObject:contentDict];
        }
        statuDict[@"children"] = mutableStatuArr;
        [_dataArr addObject:statuDict];
        
        NSMutableDictionary *timeDict = [NSMutableDictionary dictionary];
        timeDict[@"title"] = @"按时间:";
        NSArray *timeArr = @[@"全部",@"7天内",@"本月内",@"近三月"];
        NSMutableArray *mutableTimeArr = [NSMutableArray array];
        for (int i=0; i<timeArr.count; i++) {
            NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
            contentDict[@"title"] = timeArr[i];
            contentDict[@"isSelect"] = i == 0 ? @"1" : @"2";
            contentDict[@"id"] = [NSNumber numberWithInt:i];
            [mutableTimeArr addObject:contentDict];
        }
        timeDict[@"children"] = mutableTimeArr;
        [_dataArr addObject:timeDict];
        

        // 添加默认选中数据
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.selectIndexPathArr addObject:indexPath];
        [self.selectIndexPathArr addObject:indexPath1];
    }
    return _dataArr;
}
-(NSMutableArray *)selectIndexPathArr{
    if (!_selectIndexPathArr) {
        _selectIndexPathArr  =[NSMutableArray array];
    }
    return _selectIndexPathArr;
}

@end
