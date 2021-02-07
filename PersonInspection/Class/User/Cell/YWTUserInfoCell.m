//
//  YWTUserInfoCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/11.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTUserInfoCell.h"

@implementation YWTUserInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}
-(void) createCell{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
    
    UIImageView *bgImageV = [[UIImageView alloc]init];
    [self addSubview:bgImageV];
    bgImageV.image = [UIImage imageChangeName:@"pic_bg"];
    [bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
    }];
    
    self.headerImageV = [[UIImageView alloc]init];
    [self addSubview:self.headerImageV];
    self.headerImageV.image = [UIImage imageNamed:@"cbl_pic_user"];
    [self.headerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgImageV.mas_centerY);
        make.centerX.equalTo(bgImageV.mas_centerX);
        make.width.height.equalTo(@90);
    }];
    self.headerImageV.layer.cornerRadius = 90/2;
    self.headerImageV.layer.masksToBounds = YES;
    self.headerImageV.layer.borderColor = [UIColor colorF2F2TextWhiteColor].CGColor;
    self.headerImageV.layer.borderWidth = 1;
    
    UIView *jobTitleLabView = [[UIView alloc]init];
    [self addSubview:jobTitleLabView];
    jobTitleLabView.backgroundColor = [UIColor orangeColor];
    
    self.jobTitleLab = [[UILabel alloc]init];
    [jobTitleLabView addSubview:self.jobTitleLab];
    self.jobTitleLab.text = @"--";
    self.jobTitleLab.textColor =  [UIColor colorF2F2TextWhiteColor];
    self.jobTitleLab.font = Font(10);
    [self.jobTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(jobTitleLabView.mas_centerX);
        make.centerY.equalTo(jobTitleLabView.mas_centerY);
    }];
    
    [jobTitleLabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.jobTitleLab.mas_left).offset(-KSIphonScreenW(10));
        make.right.equalTo(weakSelf.jobTitleLab.mas_right).offset(KSIphonScreenW(10));
        make.height.equalTo(@18);
        make.centerY.equalTo(weakSelf.headerImageV.mas_bottom);
        make.centerX.equalTo(weakSelf.headerImageV.mas_centerX);
    }];
    jobTitleLabView.layer.cornerRadius = 9;
    jobTitleLabView.layer.masksToBounds = YES;
    
    // 名字
    self.nameLab = [[UILabel alloc]init];
    [self addSubview:self.nameLab];
    self.nameLab.text = @"--";
    self.nameLab.textColor = [UIColor colorF2F2TextWhiteColor];
    self.nameLab.font = BFont(20);
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(jobTitleLabView.mas_bottom).offset(KSIphonScreenH(7));
        make.centerX.equalTo(jobTitleLabView.mas_centerX);
    }];
    
    UIImageView *bgCompanyImageV = [[UIImageView alloc]init];
    [self addSubview:bgCompanyImageV];
    bgCompanyImageV.image = [UIImage imageChangeName:@"pic_grzx_02"];
    [bgCompanyImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgImageV.mas_bottom);
        make.centerX.equalTo(bgImageV.mas_centerX);
    }];
    
    UIView *companyView = [[UIView alloc]init];
    [self addSubview:companyView];
    
    UIImageView *companyDepaImageV = [[UIImageView alloc]init];
    [companyView addSubview:companyDepaImageV];
    companyDepaImageV.image = [UIImage imageNamed:@"ico_grzx_01"];
    companyDepaImageV.contentMode = UIViewContentModeScaleAspectFit;
    [companyDepaImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(companyView.mas_top);
        make.left.equalTo(companyView.mas_left);
    }];
    
    self.companyDepaLab = [[UILabel alloc]init];
    [companyView addSubview:self.companyDepaLab];
    self.companyDepaLab.text = @"--";
    self.companyDepaLab.textColor = [UIColor colorNamlCommonTextColor];
    self.companyDepaLab.font = Font(12);
    [self.companyDepaLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(companyView.mas_top);
        make.left.equalTo(companyDepaImageV.mas_right).offset(KSIphonScreenW(8));
    }];
    
    UIImageView *companyImageV = [[UIImageView alloc]init];
    [companyView addSubview:companyImageV];
    companyImageV.image = [UIImage imageNamed:@"ico_grzx_02"];
    companyImageV.contentMode = UIViewContentModeScaleAspectFit;
    [companyImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(companyDepaImageV.mas_bottom).offset(KSIphonScreenH(10));
        make.left.equalTo(companyDepaImageV.mas_left);
    }];
    
    self.companyLab = [[UILabel alloc]init];
    [companyView addSubview:self.companyLab];
    self.companyLab.text = @"--";
    self.companyLab.textColor = [UIColor colorNamlCommonTextColor];
    self.companyLab.font = Font(12);
    [self.companyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(companyDepaImageV.mas_bottom).offset(KSIphonScreenH(10));
        make.left.equalTo(weakSelf.companyDepaLab.mas_left);
    }];
    
    [companyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.companyDepaLab.mas_top);
        make.left.equalTo(bgCompanyImageV.mas_left).offset(KSIphonScreenW(28));
        make.right.equalTo(bgCompanyImageV.mas_right).offset(-KSIphonScreenW(28));
        make.bottom.equalTo(weakSelf.companyLab.mas_bottom);
        make.centerY.equalTo(bgCompanyImageV.mas_centerY);
    }];

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
