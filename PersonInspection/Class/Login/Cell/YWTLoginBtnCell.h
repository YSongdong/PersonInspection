//
//  YWTLoginBtnCell.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/9.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTLoginBtnCell : UITableViewCell

// 点击按钮
@property (nonatomic,copy) void(^clickLoginBtn)(void);


@end

NS_ASSUME_NONNULL_END
