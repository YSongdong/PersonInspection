//
//  YWTNewRsultListCell.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/7/6.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTNewRsultListCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dict;
// 点击解绑按钮
@property (nonatomic,copy) void(^selectCell)(void);
@property (nonatomic,copy) void(^selectPic)(NSInteger tag);
// 点击解绑按钮
@property (nonatomic,copy) void(^selectUnbundBtn)(void);

@end

NS_ASSUME_NONNULL_END
