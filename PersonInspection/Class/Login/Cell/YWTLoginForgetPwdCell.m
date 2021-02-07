//
//  YWTLoginForgetPwdCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/9.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTLoginForgetPwdCell.h"

@implementation YWTLoginForgetPwdCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}
-(void) createCell{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btn];
    [btn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorNamlCommonTextColor] forState:UIControlStateNormal];
    [btn setTitleColor:[[UIColor colorNamlCommonTextColor]colorWithAlphaComponent:0.8] forState:UIControlStateSelected];
    btn.titleLabel.font = BFont(14);
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(22));
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    [btn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}
-(void) selectBtnAction:(UIButton*)sender{
    [self showErrorWithTitle:@"请联系管理员!"];
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
