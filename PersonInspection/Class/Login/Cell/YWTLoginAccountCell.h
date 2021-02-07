//
//  YWTLoginAccountCell.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/9.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTLoginAccountCell : UITableViewCell
//textfield
@property (nonatomic,strong) UITextField *accountTextField;
//清除按钮
@property (nonatomic,strong) UIButton *clearBtn;
// 左边UIimageV
@property (nonatomic,strong)  UIImageView *leftImageV;
// textField 提示str
@property (nonatomic,strong) NSString *placeholderStr;
//textField 提示颜色
@property (nonatomic,strong) UIColor *placeColor;
// textField 提示 字体大小
@property (strong,nonatomic)UIFont *placeTextFont;
// 底部线条View 颜色
@property (nonatomic,strong) UIView *bottomLineView;

@end

NS_ASSUME_NONNULL_END
