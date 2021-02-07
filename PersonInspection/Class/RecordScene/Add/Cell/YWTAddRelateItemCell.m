//
//  YWTAddRelateItemCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/16.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTAddRelateItemCell.h"

@implementation YWTAddRelateItemCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self =  [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorLineCommonTextColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(12));
        make.bottom.equalTo(weakSelf);
        make.height.equalTo(@1);
    }];
    
    self.baseTitleLab = [[UILabel alloc]init];
    [self addSubview:self.baseTitleLab];
    self.baseTitleLab.text = @"";
    self.baseTitleLab.textColor = [UIColor colorNamlCommonTextColor];
    self.baseTitleLab.font = Font(16);
    [self.baseTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.equalTo(@70);
    }];
    
    self.itmeTextF = [[UITextField alloc]init];
    [self addSubview:self.itmeTextF];
    self.itmeTextF.textColor = [UIColor colorNamlCommonTextColor];
    self.itmeTextF.font = Font(15);
    self.itmeTextF.placeholder = @"请输入";
    self.itmeTextF.textAlignment = NSTextAlignmentRight;
    self.itmeTextF.delegate = self;
    
    [self.itmeTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineView.mas_right);
        make.top.bottom.equalTo(weakSelf);
        make.left.equalTo(weakSelf.baseTitleLab.mas_right).offset(KSIphonScreenW(30));
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)setModel:(YWTAddRecordModel *)model{
    _model = model;
    
    self.baseTitleLab.text = model.titleStr;
    
    self.itmeTextF.text = model.subTitleStr;
    
}

-(void)keyboardWillHide:(NSNotification*)tifi{
    [self.itmeTextF resignFirstResponder];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -----  UITextFieldDelegate ----
// 点击完成按钮
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    self.model.subTitleStr = textField.text;
    self.selectDone(self.model);
    return YES;
}
// 开始编辑
- (void)textFieldDidBeginEditing:(UITextField*)textField{
    //显示
   
}
// 结束编辑
-(void)textFieldDidEndEditing:(UITextField *)textField{
    //隐藏
    [textField resignFirstResponder];
    self.model.subTitleStr = textField.text;
    self.selectDone(self.model);
}


@end
