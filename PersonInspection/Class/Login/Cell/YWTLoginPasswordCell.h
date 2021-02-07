//
//  YWTLoginPasswordCell.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/9.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTLoginPasswordCell : UITableViewCell <UITextFieldDelegate>
//textfield
@property (nonatomic,strong) UITextField *pwdTextField;
//清除按钮
@property (nonatomic,strong) UIButton *clearBtn;
//查看按钮
@property (nonatomic,strong) UIButton *lookBtn;
// 左边按钮
@property (nonatomic,strong)  UIImageView *leftImageV;
// 底部线条View 颜色
@property (nonatomic,strong) UIView *bottomLineView;
@end

NS_ASSUME_NONNULL_END
