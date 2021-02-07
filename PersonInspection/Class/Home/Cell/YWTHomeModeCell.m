//
//  YWTHomeModeCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/9.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTHomeModeCell.h"

@implementation YWTHomeModeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}
-(void) createCell{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    
    self.modeBgImageV = [[UIImageView alloc]init];
    [self addSubview:self.modeBgImageV];
    self.modeBgImageV.image = [UIImage imageNamed:@""];
    [self.modeBgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(KSIphonScreenH(6));
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(23));
        make.bottom.equalTo(weakSelf).offset(-KSIphonScreenH(6));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(23));
    }];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    
    self.modeImageV = [[UIImageView alloc]init];
    [bgView addSubview:self.modeImageV];
    self.modeImageV.image = [UIImage imageChangeName:@"sy_ico_01"];
    [self.modeImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left);
    }];
    
    self.modeTitleLab = [[UILabel alloc]init];
    [bgView addSubview:self.modeTitleLab];
    self.modeTitleLab.text = @"精准查询";
    self.modeTitleLab.textColor = [UIColor colorTextWhiteColor];
    self.modeTitleLab.font = BFont(18);
    [self.modeTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(weakSelf.modeImageV.mas_right).offset(KSIphonScreenW(16));
    }];
    
    self.modeSubtitleLab = [[UILabel alloc]init];
    [bgView addSubview:self.modeSubtitleLab];
    self.modeSubtitleLab.text = @"人在现场，人/证合一认证";
    self.modeSubtitleLab.font = Font(12);
    self.modeSubtitleLab.textColor = [UIColor colorTextWhiteColor];
    [self.modeSubtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.modeTitleLab.mas_bottom).offset(KSIphonScreenH(5));
        make.left.equalTo(weakSelf.modeTitleLab.mas_left);
    }];
    
    UIImageView *imageV = [[UIImageView alloc]init];
    [bgView addSubview:imageV];
    imageV.image = [UIImage imageNamed:@"sy_ico_03"];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right);
        make.centerY.equalTo(bgView.mas_centerY);
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.modeTitleLab.mas_top);
        make.left.equalTo(weakSelf.modeBgImageV.mas_left).offset(KSIphonScreenW(18));
        make.bottom.equalTo(weakSelf.modeSubtitleLab.mas_bottom);
        make.right.equalTo(weakSelf.modeBgImageV.mas_right).offset(-KSIphonScreenW(18));
        make.centerX.equalTo(weakSelf.modeBgImageV.mas_centerX);
        make.centerY.equalTo(weakSelf.modeBgImageV.mas_centerY);
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
