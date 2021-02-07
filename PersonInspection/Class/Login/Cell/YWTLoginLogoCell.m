//
//  YWTLoginLogoCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/9.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTLoginLogoCell.h"

@implementation YWTLoginLogoCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}
-(void) createCell{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    
    UIImageView *bigImageV = [[UIImageView alloc]init];
    [self addSubview:bigImageV];
    bigImageV.image = [UIImage imageNamed:@""];
    [bigImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    UIImageView *bgImageV = [[UIImageView alloc]init];
    [self addSubview:bgImageV];
    bgImageV.image = [UIImage imageChangeName:@"login_pic"];
    [bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(KSNaviTopHeight+20);
        make.left.right.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
    UIImageView *logoImageV = [[UIImageView alloc]init];
    [self addSubview:logoImageV];
    logoImageV.image = [UIImage imageChangeName:@"login_logo_01"];
    [logoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgImageV.mas_centerY);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
    UIImageView *textImageV = [[UIImageView alloc]init];
    [self addSubview:textImageV];
    textImageV.image = [UIImage imageChangeName:@"login_pic_text"];
    [textImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImageV.mas_bottom).offset(KSIphonScreenH(19));
        make.centerX.equalTo(logoImageV.mas_centerX);
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
