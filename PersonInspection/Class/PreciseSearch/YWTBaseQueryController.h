//
//  YWTPreciseSearchController.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/12.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    showViewControllerSearchType = 0,  // 精准查询
    showViewControllerQuickSearchType , // 快速查询
}showViewControllerType;

@interface YWTBaseQueryController : YWTBaseViewController
// 类型
@property (nonatomic,assign) showViewControllerType viewType;
// 是不是精准查询
@property (nonatomic,assign) BOOL isAccurateQuery;
// 判断是高精度，
@property (nonatomic,assign) BOOL isAccurateBasic;
@end

NS_ASSUME_NONNULL_END
