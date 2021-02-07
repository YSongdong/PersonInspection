//
//  YWTUserModuleCell.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/11.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTUserModuleCell : UITableViewCell
// 模块图片
@property (nonatomic,strong) UIImageView *moduleImageV;
// 模块名称
@property (nonatomic,strong) UILabel *moduleNameLab;

@property (nonatomic,strong) UILabel *moduleSubLab;

@end

NS_ASSUME_NONNULL_END
