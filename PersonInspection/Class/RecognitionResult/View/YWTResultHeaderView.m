//
//  YWTResultHeaderView.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/8/19.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTResultHeaderView.h"

@implementation YWTResultHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
    
    self.statuBgView = [[UIView alloc]init];
    [self addSubview:self.statuBgView];
    self.statuBgView.backgroundColor = [UIColor colorWithHexString:@"#e1efe7"];
    [self.statuBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(KSIphonScreenH(7));
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(12));
        make.bottom.equalTo(weakSelf);
    }];
    self.statuBgView.layer.cornerRadius = 10/2;
    self.statuBgView.layer.masksToBounds = YES;
    self.statuBgView.layer.borderWidth = 1;
    self.statuBgView.layer.borderColor = [UIColor colorWithHexString:@"#aedcc2"].CGColor;
    self.statuBgView.alpha = 0.9;
    
    self.statuImageV = [[UIImageView alloc]init];
    [self.statuBgView addSubview:self.statuImageV];
    self.statuImageV.image = [UIImage imageNamed:@"jlxc_ico_tips_02"];
    self.statuImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.statuImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.statuBgView).offset(KSIphonScreenW(12));
        make.centerY.equalTo(weakSelf.statuBgView.mas_centerY);
    }];

    self.statuPromptLab = [[UILabel alloc]init];
    [self.statuBgView addSubview:self.statuPromptLab];
    self.statuPromptLab.text = @"";
    self.statuPromptLab.textColor = [UIColor colorWithHexString:@"#28b04a"];
    self.statuPromptLab.font = Font(12);
    [self.statuPromptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.statuImageV.mas_right).offset(KSIphonScreenW(7));
        make.centerY.equalTo(weakSelf.statuImageV.mas_centerY);
    }];
}
// 适配深色模式
-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    if (@available(iOS 13.0, *)) {
        if (previousTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
           self.statuBgView.backgroundColor = [UIColor colorWithHexString:@"#e1efe7"];
           self.statuBgView.layer.borderColor = [UIColor colorWithHexString:@"#aedcc2"].CGColor;
        }else{
            self.statuBgView.backgroundColor = [UIColor colorViewShallowDarkBlackColor];
            self.statuBgView.layer.borderColor = [UIColor colorWithHexString:@"#404856"].CGColor;
        }
    } else {
        self.statuBgView.backgroundColor = [UIColor colorWithHexString:@"#e1efe7"];
        self.statuBgView.layer.borderColor = [UIColor colorWithHexString:@"#aedcc2"].CGColor;
    }
}
@end
