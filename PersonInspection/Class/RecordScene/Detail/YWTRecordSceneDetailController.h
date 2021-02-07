//
//  YWTRecordSceneDetailController.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/18.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTRecordSceneDetailController : YWTBaseViewController

@property (nonatomic,strong) NSString *idStr;
// 数据源
@property (nonatomic,strong) NSArray *dataDictArr;

@property (nonatomic,strong) YWTCertificateModel *model;

@end

NS_ASSUME_NONNULL_END
