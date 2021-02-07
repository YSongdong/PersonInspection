//
//  YWTRecognResultController.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/19.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTRecognResultController : YWTBaseViewController
// 是不是精准查询
@property (nonatomic,assign) BOOL isAccurateQuery;
// 数据源
@property (nonatomic,strong) NSDictionary *dataDict;
// 传值
@property (nonatomic,strong) YWTCertificateModel *model;
// 是不是手动输入   YES 是 默认NO
@property (nonatomic,assign) BOOL isEnter;

@end

NS_ASSUME_NONNULL_END
