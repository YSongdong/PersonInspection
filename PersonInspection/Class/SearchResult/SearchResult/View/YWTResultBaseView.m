//
//  YWTResultBaseView.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/20.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTResultBaseView.h"

@implementation YWTResultBaseView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(instancetype)init{
    if (self = [super init]) {
        [self createView];
    }
    return self;
}

-(void) createView{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    
    self.titleLab = [[UILabel alloc]init];
    [self addSubview:self.titleLab];
    self.titleLab.text = @"";
    self.titleLab.textColor = [UIColor colorNamlCommon98TextColor];
    self.titleLab.font = Font(13);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    self.subTitleLab = [[UILabel alloc]init];
    [self addSubview:self.subTitleLab];
    self.subTitleLab.text = @"";
    self.subTitleLab.textColor = [UIColor colorNamlCommonTextColor];
    self.subTitleLab.font = Font(13);
    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(12));
        make.centerY.equalTo(weakSelf.titleLab.mas_centerY);
        make.width.lessThanOrEqualTo(@(KSIphonScreenW(230)));
    }];
    
    self.lineImageV = [[UIImageView alloc]init];
    [self addSubview:self.lineImageV];
    self.lineImageV.image = [UIImage imageNamed:@"cxjg_pic_line"];
    [self.lineImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(12));
        make.bottom.equalTo(weakSelf);
    }];
    self.lineImageV.hidden = YES;
}



@end
