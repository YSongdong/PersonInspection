//
//  YWTAddRecordSceneController.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/15.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTAddRecordSceneController : YWTBaseViewController

//  是不是精准查询
@property (nonatomic,assign) BOOL *isPreciseQuery;

@property (nonatomic,strong) YWTCertificateModel *model;
@end

NS_ASSUME_NONNULL_END
