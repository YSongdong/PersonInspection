//
//  YWTRecordPhotoCell.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/15.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWTAddRecordModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YWTRecordPhotoCell : UICollectionViewCell
// 显示
@property (nonatomic,strong) YWTAddRecordModel *showModel;

@property (nonatomic,assign) BOOL isHiddenDelBtn;
// 添加
@property (nonatomic,strong) YWTAddRecordModel *model;
// 点击删除按钮
@property (nonatomic,copy) void(^selectCellDel)(void);
@end

NS_ASSUME_NONNULL_END
