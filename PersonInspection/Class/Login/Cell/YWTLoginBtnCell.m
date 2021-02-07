//
//  YWTLoginBtnCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/9.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTLoginBtnCell.h"

@implementation YWTLoginBtnCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}
-(void) createCell{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:btn];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = BFont(17);
    [btn setBackgroundImage:[UIImage imageChangeName:@"cxjg_btn_nor"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageChangeName:@"cxjg_btn_sel"] forState:UIControlStateHighlighted];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(22));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(22));
        make.top.equalTo(weakSelf).offset(KSIphonScreenH(22));
        make.height.equalTo(@(55));
    }];
    btn.layer.shadowOffset = CGSizeMake(0, 5);
    if (KTargetPerson_CS) {
        btn.layer.shadowColor = [UIColor colorBlueTextColor].CGColor;
    }else{
        btn.layer.shadowColor = [UIColor colorWithHexString:@"#0022b4"].CGColor;
    }
    btn.layer.shadowRadius = 3;
    btn.layer.shadowOpacity = 0.35;
    btn.layer.masksToBounds = NO;
    [btn addTarget:self action:@selector(selectLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)selectLoginBtn:(UIButton*)sender{
    self.clickLoginBtn();
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
