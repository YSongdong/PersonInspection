//
//  YWAlterPwdModuleCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/11.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWAlterPwdModuleCell.h"

@implementation YWAlterPwdModuleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}
-(void) createCell{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorWithHexString:@"#1e2838"] normalCorlor:[UIColor colorTextWhiteColor]];

    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorLineCommonTextColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(12));
        make.bottom.equalTo(weakSelf);
        make.height.equalTo(@1);
    }];
    
    self.moduleTitleLab = [[UILabel alloc]init];
    [self addSubview:self.moduleTitleLab];
    self.moduleTitleLab.text = @"原密码";
    self.moduleTitleLab.textColor = [UIColor colorNamlCommonTextColor];
    self.moduleTitleLab.font = Font(15);
    [self.moduleTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(24));
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    self.moduleTextF = [[UITextField alloc]init];
    [self addSubview:self.moduleTextF];
    self.moduleTextF.textColor = [UIColor colorNamlCommonTextColor];
    self.moduleTextF.returnKeyType = UIReturnKeyDone;
    self.moduleTextF.delegate = self;
    self.moduleTextF.secureTextEntry = YES;
    [self.moduleTextF mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(weakSelf).offset(KSIphonScreenW(100));
       make.top.bottom.equalTo(weakSelf);
       make.right.equalTo(weakSelf.mas_right);
       make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    // 查看按钮
    self.lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.lookBtn];
    [self.lookBtn setImage:[UIImage imageChangeName:@"xgmm_ico_off"] forState:UIControlStateNormal];
    [self.lookBtn setImage:[UIImage imageChangeName:@"xgmm_ico_on"] forState:UIControlStateSelected];
    [self.lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineView.mas_right).offset(-KSIphonScreenW(10));
       make.centerY.equalTo(weakSelf.mas_centerY);
       make.width.equalTo(@28);
    }];
    //隐藏
    self.lookBtn.hidden = YES;
    [self.lookBtn addTarget:self action:@selector(selectLookBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    // 清除按钮
    self.clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.clearBtn];
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
        self.moduleTextF.secureTextEntry = NO;
    }else{
        self.moduleTextF.secureTextEntry = YES;
    }
}
//点击清除按钮
-(void) selectClearBtn:(UIButton *) sender{
    self.moduleTextF.text = @"";
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
    self.lookBtn.hidden = NO;
}
// 结束编辑
-(void)textFieldDidEndEditing:(UITextField *)textField{
    //隐藏
    self.clearBtn.hidden = YES;
    self.lookBtn.hidden = YES;
}

-(void)setModulePlaceholderText:(NSString *)modulePlaceholderText{
    _modulePlaceholderText =  modulePlaceholderText;
    //设置颜色和大小
    self.moduleTextF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:modulePlaceholderText attributes:@{NSForegroundColorAttributeName : [UIColor colorPlaceholderTextColor],NSFontAttributeName  :[UIFont systemFontOfSize:15]}];
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
