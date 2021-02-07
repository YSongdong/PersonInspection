//
//  YWAlterPwdModuleCell.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/11.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWAlterPwdModuleCell : UITableViewCell <UITextFieldDelegate>
//清除按钮
@property (nonatomic,strong) UIButton *clearBtn;
//查看按钮
@property (nonatomic,strong) UIButton *lookBtn;
// 模块名称
@property (nonatomic,strong) UILabel *moduleTitleLab;

@property (nonatomic,strong) UITextField *moduleTextF;
// 模块提示文字
@property (nonatomic,strong) NSString *modulePlaceholderText;

@end

NS_ASSUME_NONNULL_END
