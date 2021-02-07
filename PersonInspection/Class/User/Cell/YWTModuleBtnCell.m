//
//  YWTUserSignOutCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/11.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTModuleBtnCell.h"

@implementation YWTModuleBtnCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}
-(void) createCell{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
    
    self.moduleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.moduleBtn];
    [self.moduleBtn setBackgroundImage:[UIImage imageChangeName:@"cxjg_btn_nor"] forState:UIControlStateNormal];
    [self.moduleBtn setBackgroundImage:[UIImage imageChangeName:@"cxjg_btn_sel"] forState:UIControlStateHighlighted];
    [self.moduleBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    self.moduleBtn.titleLabel.font = BFont(17);
    [self.moduleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(-KSIphonScreenH(10));
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(17));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(17));
        make.height.equalTo(@55);
    }];
    self.moduleBtn.layer.shadowOffset = CGSizeMake(0, 5);
    if (KTargetPerson_CS) {
        self.moduleBtn.layer.shadowColor = [UIColor colorBlueTextColor].CGColor;
    }else{
        self.moduleBtn.layer.shadowColor = [UIColor colorWithHexString:@"#0022b4"].CGColor;
    }
    self.moduleBtn.layer.shadowRadius = 3;
    self.moduleBtn.layer.shadowOpacity = 0.35;
    self.moduleBtn.layer.masksToBounds = NO;
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
