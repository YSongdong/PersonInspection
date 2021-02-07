//
//  YWTLoginAccountCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/9.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTLoginAccountCell.h"

@interface YWTLoginAccountCell ()<UITextFieldDelegate>

@end

@implementation YWTLoginAccountCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}
-(void) createCell{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    
    //线条view
    self.bottomLineView = [[UIView alloc]init];
    [self.contentView addSubview:self.bottomLineView];
    self.bottomLineView.backgroundColor = [UIColor colorLineCommonTextColor];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(22));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(22));
        make.bottom.equalTo(weakSelf);
        make.height.equalTo(@1);
    }];
    
    self.leftImageV = [[UIImageView alloc]init];
    [self.contentView addSubview:self.leftImageV];
    self.leftImageV.image = [UIImage imageChangeName:@"login_ico_01"];
    self.leftImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bottomLineView.mas_left).offset(KSIphonScreenW(5));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.equalTo(@30);
    }];
    
    // 输入框
    self.accountTextField = [[UITextField alloc]init];
    [self.contentView addSubview:self.accountTextField];
    self.accountTextField.placeholder = @"请输入管理员账号";
    self.accountTextField.textColor = [UIColor colorNamlCommonTextColor];
    self.accountTextField.font = Font(16);
    self.accountTextField.delegate = self;
    self.accountTextField.returnKeyType = UIReturnKeyDone;
    //设置颜色和大小
    self.accountTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入管理员账号" attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15],NSForegroundColorAttributeName : [UIColor colorPlaceholderTextColor]}];
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(KSIphonScreenW(6));
        make.top.bottom.equalTo(weakSelf);
        make.right.equalTo(weakSelf.bottomLineView.mas_right);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    [self.accountTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    // 清除按钮
    self.clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.clearBtn];
    [self.clearBtn setImage:[UIImage imageChangeName:@"login_ico_delete"] forState:UIControlStateNormal];
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bottomLineView.mas_right);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.equalTo(@28);
    }];
    //隐藏
    self.clearBtn.hidden = YES;
    [self.clearBtn addTarget:self action:@selector(selectClearBtn:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark ----- 按钮点击方法 ----
//监听键盘输入
- (void)textFieldChanged:(UITextField*)textField{
    //默认颜色
    self.accountTextField.textColor = [UIColor colorNamlCommonTextColor];
    // 默认线条颜色
    self.bottomLineView.backgroundColor = [UIColor colorLineCommonTextColor];
}
//点击清除按钮
-(void) selectClearBtn:(UIButton *) sender{
    self.accountTextField.text = @"";
}
#pragma mark -----  UITextFieldDelegate ---- 
// 点击完成按钮
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
// 开始编辑
- (void)textFieldDidBeginEditing:(UITextField*)textField{
    //显示
    self.clearBtn.hidden = NO;
}
// 结束编辑
-(void)textFieldDidEndEditing:(UITextField *)textField{
    //隐藏
    self.clearBtn.hidden = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
