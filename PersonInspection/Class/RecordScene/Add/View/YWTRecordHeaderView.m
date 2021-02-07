//
//  YWTRecordHeaderView.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/16.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTRecordHeaderView.h"

@implementation YWTRecordHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self craeteView];
    }
    return self;
}
-(void) craeteView{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#fff8ee"];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf);
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(12));
    }];
    bgView.layer.cornerRadius = 10/2;
    bgView.layer.masksToBounds = YES;
    bgView.layer.borderWidth =1;
    bgView.layer.borderColor = [UIColor colorWithHexString:@"#fbdfb8"].CGColor;
    
    UIButton *delegateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:delegateBtn];
    [delegateBtn setImage:[UIImage imageNamed:@"jlxc_btn_delete"] forState:UIControlStateNormal];
    [delegateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(bgView);
        make.right.equalTo(bgView).offset(-KSIphonScreenW(3));
        make.width.equalTo(@30);
    }];
    [delegateBtn addTarget:self action:@selector(selectDelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *promptImageV = [[UIImageView alloc]init];
    [bgView addSubview:promptImageV];
    promptImageV.image = [UIImage imageNamed:@"jlxc_ico_tips"];
    promptImageV.contentMode =  UIViewContentModeScaleAspectFit;
    [promptImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(KSIphonScreenW(10));
        make.centerY.equalTo(bgView.mas_centerY);
    }];
    
    UILabel *promptLab = [[UILabel alloc]init];
    [bgView addSubview:promptLab];
    promptLab.text = @"照片作为关键证据，请尽量上传，最多可上传9张";
    promptLab.textColor = [UIColor colorWithHexString:@"#f6a304"];
    promptLab.font = Font(12);
    [promptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(promptImageV.mas_right).offset(KSIphonScreenW(5));
        make.centerY.equalTo(promptImageV.mas_centerY);
    }];
}
-(void) selectDelBtn:(UIButton*)sender{
    self.selectDelBtn();
}



@end
