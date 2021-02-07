//
//  YWTLoginPasswordCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/9.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTLoginPasswordCell.h"

@implementation YWTLoginPasswordCell

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
    self.leftImageV.image = [UIImage imageChangeName:@"login_ico_02"];
    self.leftImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bottomLineView.mas_left).offset(KSIphonScreenW(5));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.equalTo(@30);
    }];
    
    // 输入框
    self.pwdTextField = [[UITextField alloc]init];
    [self.contentView addSubview:self.pwdTextField];
    self.pwdTextField.placeholder = @"请输入管理员登录密码";
    self.pwdTextField.textColor = [UIColor colorNamlCommonTextColor];
    self.pwdTextField.font = Font(16);
    self.pwdTextField.delegate = self;
    self.pwdTextField.returnKeyType = UIReturnKeyDone;
    self.pwdTextField.secureTextEntry = YES;
    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(KSIphonScreenW(6));
        make.top.bottom.equalTo(weakSelf);
        make.right.equalTo(weakSelf.bottomLineView.mas_right);
        make.centerY.equalTo(weakSelf.mas_centerY);
     }];
     [self.pwdTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
     //设置颜色和大小
     self.pwdTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入管理员登录密码" attributes:@{NSForegroundColorAttributeName : [UIColor colorPlaceholderTextColor],NSFontAttributeName  :[UIFont systemFontOfSize:15]}];
    
    // 查看按钮
    self.lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.lookBtn];
    [self.lookBtn setImage:[UIImage imageChangeName:@"xgmm_ico_off"] forState:UIControlStateNormal];
    [self.lookBtn setImage:[UIImage imageChangeName:@"xgmm_ico_on"] forState:UIControlStateSelected];
    [self.lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bottomLineView.mas_right).offset(-KSIphonScreenW(5));
       make.centerY.equalTo(weakSelf.mas_centerY);
       make.width.equalTo(@28);
    }];
    //隐藏
    [self.lookBtn addTarget:self action:@selector(selectLookBtn:) forControlEvents:UIControlEventTouchUpInside];

    // 清除按钮
    self.clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.clearBtn];
    [self.clearBtn setImage:[UIImage imageChangeName:@"login_ico_delete"] forState:UIControlStateNormal];
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.lookBtn.mas_left).offset(-KSIphonScreenW(10));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.equalTo(@28);
    }];
    //隐藏
    self.clearBtn.hidden = YES;
    [self.clearBtn addTarget:self action:@selector(selectClearBtn:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark ----- 按钮点击方法 ----
-(void)selectLookBtn:(UIButton *) sender{
    sender.selected =! sender.selected;
    if (sender.selected) {
        self.pwdTextField.secureTextEntry = NO;
    }else{
        self.pwdTextField.secureTextEntry = YES;
    }
}
//点击清除按钮
-(void) selectClearBtn:(UIButton *) sender{
    self.pwdTextField.text = @"";
}
//监听键盘输入
- (void)textFieldChanged:(UITextField*)textField{
    //默认颜色
    self.pwdTextField.textColor = [UIColor colorNamlCommonTextColor];
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
