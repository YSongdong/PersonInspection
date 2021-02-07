//
//  YWTHeaderSearchView.m
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/21.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import "YWTHeaderSearchView.h"

@interface YWTHeaderSearchView ()<UITextFieldDelegate>

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIButton *clearBtn;
@end

@implementation YWTHeaderSearchView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createSearchView];
    }
    return self;
}
-(void) createSearchView{
    self.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
    WS(weakSekf);
    self.bgView = [[UIView alloc]init];
    [self addSubview:self.bgView];
    self.bgView.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSekf).offset(KSIphonScreenH(8));
        make.left.equalTo(weakSekf).offset(KSIphonScreenW(10));
        make.right.equalTo(weakSekf).offset(-KSIphonScreenW(10));
        make.bottom.equalTo(weakSekf).offset(-KSIphonScreenH(8));
    }];
    self.bgView.layer.cornerRadius = (CGRectGetHeight(self.frame)-KSIphonScreenH(16))/2;
    self.bgView.layer.masksToBounds = YES;
    UITapGestureRecognizer *tapBgView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTapBgView)];
    [self.bgView addGestureRecognizer:tapBgView];
    
    self.leftImageV = [[UIImageView alloc]init];
    [self.bgView addSubview:self.leftImageV];
    self.leftImageV.image  =[UIImage imageNamed:@"line_headerl_search"];
    self.leftImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSekf.bgView).offset((KScreenW-24)/4);
        make.width.equalTo(@(KSIphonScreenW(20)));
        make.centerY.equalTo(weakSekf.bgView.mas_centerY);
    }];
    
    self.searchTF = [[UITextField alloc]init];
    [self.bgView addSubview:self.searchTF];
    self.searchTF.attributedPlaceholder  = [[NSMutableAttributedString alloc]initWithString:@"输入证件号码或姓名精确查找" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#cccccc"]}];
    self.searchTF.textColor = [UIColor colorNamlCommonTextColor];
    self.searchTF.font = Font(14);
    self.searchTF.delegate = self;
    self.searchTF.returnKeyType = UIReturnKeySearch;
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSekf.leftImageV.mas_right).offset(KSIphonScreenW(10));
        make.right.height.equalTo(weakSekf.bgView);
        make.centerY.equalTo(weakSekf.bgView.mas_centerY);
    }];
    
    self.clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [weakSekf.bgView addSubview:self.clearBtn];
    [self.clearBtn setImage:[UIImage imageNamed:@"jlxc_pic_delete"] forState:UIControlStateNormal];
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSekf.bgView).offset(-KSIphonScreenW(10));
        make.centerY.equalTo(weakSekf.bgView.mas_centerY);
    }];
    [self.clearBtn addTarget:self action:@selector(selectClearBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.clearBtn.hidden =  YES;
}
-(void) selectClearBtn:(UIButton *) sender{
    self.searchTF.text = @"";
}
-(void)selectTapBgView{
    __weak typeof(self) weakSelf = self;
    // 进入开始编辑
    [UIView animateWithDuration:0.25 animations:^{
        // 更新约束
        [weakSelf.leftImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.bgView).offset(KSIphonScreenW(10));
        }];
        // 获取焦点
        [weakSelf.searchTF becomeFirstResponder];
        // 显示清除按钮
        weakSelf.clearBtn.hidden = NO;
    }];
}
// 文本字段将成为第一响应者
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    __weak typeof(self) weakSelf = self;
    // 进入开始编辑
    [UIView animateWithDuration:0.25 animations:^{
        // 更新约束
        [weakSelf.leftImageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.bgView).offset(KSIphonScreenW(10));
        }];
        // 显示清除按钮
        weakSelf.clearBtn.hidden = NO;
    }];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:@""]) {
        __weak typeof(self) weakSelf = self;
        // 结束编辑时
        [UIView animateWithDuration:0.25 animations:^{
            // 更新约束
            [weakSelf.leftImageV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.bgView).offset((KScreenW-24)/4);
            }];
        }];
    }
    // 显示清除按钮
    self.clearBtn.hidden = YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(selectSearchBtn:)]) {
        [self.delegate selectSearchBtn:textField.text];
    }
    return YES;
}


@end
