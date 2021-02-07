//
//  YWTResultRefreshView.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/20.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTResultRefreshView : UIView

// 判断是不是记录
@property (nonatomic,assign) BOOL isRecord;

@property (nonatomic,strong) UIButton *refreshBtn;

@property (nonatomic,strong) UILabel *idNumberLab;

@property (nonatomic,copy) void(^selectRefreshBtn)(void);

@end

NS_ASSUME_NONNULL_END
