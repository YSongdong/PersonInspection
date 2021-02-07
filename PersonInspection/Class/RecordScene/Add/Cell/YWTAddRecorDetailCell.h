//
//  YWTAddRecorDetailCell.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/16.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTextView.h"
#import "YWTAddRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YWTAddRecorDetailCell : UICollectionViewCell <UITextViewDelegate>

@property (nonatomic,strong) YWTAddRecordModel *model;

@property (nonatomic,strong) FSTextView *fsTextView;

// 点击描述完成
@property (nonatomic,copy) void(^selectDetailDone)(YWTAddRecordModel *model);
@end

NS_ASSUME_NONNULL_END
