//
//  YWTHomeUserCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/9.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTHomeUserCell.h"

@implementation YWTHomeUserCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}
-(void) createCell{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    
    UIImageView *showImageV = [[UIImageView alloc]init];
    [self addSubview:showImageV];
    showImageV.image  = [UIImage imageNamed:@"sy_pic_01"];
    [showImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(KSIphonScreenH(42));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(23));
    }];
    
    self.nameLab = [[UILabel alloc]init];
    [self addSubview:self.nameLab];
    self.nameLab.textColor = [UIColor colorNamlCommonTextColor];
    self.nameLab.font = BFont(23);
    self.nameLab.text = @"Hi";
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(23));
        make.top.equalTo(showImageV.mas_centerY);
    }];
    
    UILabel *markLab = [[UILabel alloc]init];
    [self addSubview:markLab];
    markLab.textColor = [UIColor colorNamlCommon65TextColor];
    markLab.font =  Font(12);
    markLab.text = @"欢迎使用特种人员身份验证系统";
    [markLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab.mas_left);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).offset(KSIphonScreenH(10));
    }];
    
    
    UIImageView *lineImageV = [[UIImageView alloc]init];
    [self  addSubview:lineImageV];
    lineImageV.image = [UIImage imageNamed:@"sy_pic_line"];
    [lineImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab.mas_left);
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(23));
        make.bottom.equalTo(weakSelf);
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
