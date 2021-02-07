//
//  YWTUserModuleCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/11.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTUserModuleCell.h"

@implementation YWTUserModuleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}
-(void) createCell{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor =[UIColor colorStyleLeDarkWithConstantColor:[UIColor colorWithHexString:@"#1e2838"] normalCorlor:[UIColor colorTextWhiteColor]];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(KSIphonScreenH(6));
        make.left.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(-KSIphonScreenH(6));
    }];
    
    self.moduleImageV = [[UIImageView alloc]init];
    [bgView addSubview:self.moduleImageV];
    self.moduleImageV.image = [UIImage imageNamed:@"ico_grzx_03"];
    self.moduleImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.moduleImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(KSIphonScreenW(17));
        make.centerY.equalTo(bgView.mas_centerY);
    }];
    
    UIImageView *rightImageV = [[UIImageView alloc]init];
    [bgView addSubview:rightImageV];
    rightImageV.image = [UIImage imageNamed:@"ico_grzx_enter"];
    rightImageV.contentMode = UIViewContentModeScaleAspectFit;
    [rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-KSIphonScreenW(17));
        make.centerY.equalTo(weakSelf.moduleImageV.mas_centerY);
        make.width.equalTo(@20);
    }];
    
    self.moduleNameLab = [[UILabel alloc]init];
    [bgView addSubview:self.moduleNameLab];
    self.moduleNameLab.text = @"";
    self.moduleNameLab.textColor = [UIColor colorNamlCommonTextColor];
    self.moduleNameLab.font = Font(13);
    [self.moduleNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.moduleImageV.mas_right).offset(KSIphonScreenW(12));
        make.centerY.equalTo(weakSelf.moduleImageV.mas_centerY);
    }];
    
    self.moduleSubLab = [[UILabel alloc]init];
    [bgView addSubview:self.moduleSubLab];
    self.moduleSubLab.text = @"";
    self.moduleSubLab.textColor = [UIColor colorNamlCommon98TextColor];
    self.moduleSubLab.font = Font(13);
    [self.moduleSubLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightImageV.mas_left).offset(-KSIphonScreenW(12));
        make.centerY.equalTo(weakSelf.moduleImageV.mas_centerY);
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
