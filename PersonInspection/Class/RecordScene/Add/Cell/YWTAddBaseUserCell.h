//
//  YWTAddBaseUserCell.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/16.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YWTAddRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YWTAddBaseUserCell : UICollectionViewCell

@property (nonatomic,strong) YWTAddRecordModel *model;

@property (nonatomic,strong) UILabel *baseTitleLab;

@property (nonatomic,strong) UILabel *baseSubTiltlLab;


@end

NS_ASSUME_NONNULL_END
