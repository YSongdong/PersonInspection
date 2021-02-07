//
//  YWTSearchResultController.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/20.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTSearchResultController : YWTBaseViewController
// 是不是精准查询
@property (nonatomic,assign) BOOL isAccurateQuery;
// web 数据源
@property (nonatomic,strong) NSDictionary *webDataSource;

@property (nonatomic,strong) NSString *idStr;
// 判断是不是记录
@property (nonatomic,assign) BOOL isRecord;
// 传值
@property (nonatomic,strong) YWTCertificateModel *model;

@end

NS_ASSUME_NONNULL_END
