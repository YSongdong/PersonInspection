//
//  YWTResultRefreshView.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/20.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTResultRefreshView.h"

@implementation YWTResultRefreshView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
    
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorBlueTextColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(24));
        make.width.equalTo(@2);
        make.height.equalTo(@11);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    UILabel *showLab = [[UILabel alloc]init];
    [self addSubview:showLab];
    showLab.text = @"Ta的证件";
    showLab.textColor = [UIColor colorNamlCommonTextColor];
    showLab.font = Font(12);
    [showLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(KSIphonScreenW(3));
        make.centerY.equalTo(lineView.mas_centerY);
    }];
    
    
    self.idNumberLab = [[UILabel alloc]init];
    [self addSubview:self.idNumberLab];
    self.idNumberLab.text = @"(2)";
    self.idNumberLab.textColor = [UIColor colorNamlCommon98TextColor];
    self.idNumberLab.font = Font(12);
    [self.idNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showLab.mas_right).offset(KSIphonScreenW(2));
        make.centerY.equalTo(showLab.mas_centerY);
    }];
    
    
    self.refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.refreshBtn];
    [self.refreshBtn setTitle:@"  刷新证件" forState:UIControlStateNormal];
    self.refreshBtn.titleLabel.font = Font(11);
    [self.refreshBtn setTitleColor:[UIColor colorBlueTextColor] forState:UIControlStateNormal];
    [self.refreshBtn setImage:[UIImage imageChangeName:@"ico_sx"] forState:UIControlStateNormal];
    [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(24));
        make.top.bottom.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    [self.refreshBtn addTarget:self action:@selector(refreshBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)setIsRecord:(BOOL)isRecord{
    _isRecord = isRecord;
    if (isRecord) {
        self.refreshBtn.hidden = YES;
    }
}

-(void)refreshBtnAction:(UIButton*)sender{
    self.selectRefreshBtn();
}





@end
