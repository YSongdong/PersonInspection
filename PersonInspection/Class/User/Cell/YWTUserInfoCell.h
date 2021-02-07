//
//  YWTUserInfoCell.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/11.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTUserInfoCell : UITableViewCell
// 头像
@property (nonatomic,strong) UIImageView *headerImageV;
// 职称
@property (nonatomic,strong) UILabel *jobTitleLab;
// 名称
@property (nonatomic,strong) UILabel *nameLab;
// 公司部门
@property (nonatomic,strong) UILabel *companyDepaLab;
// 公司
@property (nonatomic,strong) UILabel *companyLab;
@end

NS_ASSUME_NONNULL_END
