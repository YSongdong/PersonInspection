//
//  YWTSearchResultController.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/14.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTResultDetailController : YWTBaseViewController

@property (nonatomic,strong) NSDictionary *dict;

@property (nonatomic,strong) NSString *statuStr;

@property (nonatomic,assign) BOOL  isRecord;

@property (nonatomic,strong) YWTCertificateModel *model;

@end

NS_ASSUME_NONNULL_END
