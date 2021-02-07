//
//  YWTBlankPageView.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/15.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTBlankPageView.h"

@implementation YWTBlankPageView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    
    self.imageV = [[UIImageView alloc]init];
    [bgView addSubview:self.imageV];
    self.imageV.image = [UIImage imageChangeName:@"cxjg_pic_01"];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.centerX.equalTo(bgView.mas_centerX);
    }];
    
    self.showTitleLab = [[UILabel alloc]init];
    [bgView addSubview:self.showTitleLab];
    self.showTitleLab.text = @"查无此证";
    self.showTitleLab.textColor = [UIColor colorNamlCommonTextColor];
    self.showTitleLab.font = BFont(23);
    [self.showTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imageV.mas_bottom).offset(KSIphonScreenH(36));
        make.centerX.equalTo(weakSelf.imageV.mas_centerX);
    }];
    
    self.showSubTitleLab = [[UILabel alloc]init];
    [bgView addSubview:self.showSubTitleLab];
    self.showSubTitleLab.text = @"请核实后重新查询或联系发证机关补登信息!";
    self.showSubTitleLab.textColor = [UIColor colorNamlCommon65TextColor];
    self.showSubTitleLab.font = Font(13);
    [self.showSubTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showTitleLab.mas_bottom).offset(KSIphonScreenH(10));
        make.centerX.equalTo(weakSelf.showTitleLab.mas_centerX);
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(KSIphonScreenH(150));
        make.left.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.showSubTitleLab.mas_bottom);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
    
    self.homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.homeBtn];
    [self.homeBtn setTitle:@"回到首页" forState:UIControlStateNormal];
    [self.homeBtn setTitleColor:[UIColor colorBlueTextColor] forState:UIControlStateNormal];
    self.homeBtn.titleLabel.font = BFont(16);
    self.homeBtn.backgroundColor = [UIColor colorTextWhiteColor];
    [self.homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(-KSIphonScreenH(50));
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(20));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(20));
        make.height.equalTo(@55);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    self.homeBtn.layer.cornerRadius = 10/2;
    self.homeBtn.layer.masksToBounds = YES;
    self.homeBtn.layer.borderWidth  = 1;
    self.homeBtn.layer.borderColor  = [UIColor colorBlueTextColor].CGColor;
    [self.homeBtn addTarget:self action:@selector(selectBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.recordBtn];
    [self.recordBtn setTitle:@"记录现场" forState:UIControlStateNormal];
    [self.recordBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    self.recordBtn.titleLabel.font = BFont(16);
    [self.recordBtn setBackgroundImage:[UIImage imageChangeName:@"cxjg_btn_nor"] forState:UIControlStateNormal];
    [self.recordBtn setBackgroundImage:[UIImage imageChangeName:@"cxjg_btn_sel"] forState:UIControlStateHighlighted];
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.homeBtn.mas_top).offset(-KSIphonScreenH(15));
        make.left.equalTo(weakSelf.homeBtn.mas_left);
        make.width.height.equalTo(weakSelf.homeBtn);
        make.centerX.equalTo(weakSelf.homeBtn.mas_centerX);
    }];
    self.recordBtn.layer.shadowOffset = CGSizeMake(0, 5);
    if (KTargetPerson_CS) {
        self.recordBtn.layer.shadowColor = [UIColor colorBlueTextColor].CGColor;
    }else{
       self.recordBtn.layer.shadowColor = [UIColor colorWithHexString:@"#0022b4"].CGColor;
    }
    self.recordBtn.layer.shadowRadius = 3;
    self.recordBtn.layer.shadowOpacity = 0.35;
    self.recordBtn.layer.masksToBounds = NO;
    [self.recordBtn addTarget:self action:@selector(selectRecordBtn:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)selectBackBtn:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(pushPageBackBtn)]) {
        [self.delegate pushPageBackBtn];
    }
}
-(void)selectRecordBtn:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(pushPageRecordBtn)]) {
        [self.delegate pushPageRecordBtn];
    }
}


@end
