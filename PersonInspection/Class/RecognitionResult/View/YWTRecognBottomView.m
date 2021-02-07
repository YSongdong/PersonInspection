//
//  YWTRecognBottomView.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/19.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTRecognBottomView.h"

@implementation YWTRecognBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =  [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
    
    self.identtifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.identtifyBtn];
    [self.identtifyBtn setTitle:@"回到首页" forState:UIControlStateNormal];
    [self.identtifyBtn setTitleColor:[UIColor colorBlueTextColor] forState:UIControlStateNormal];
    self.identtifyBtn.titleLabel.font = BFont(16);
    self.identtifyBtn.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorViewDarkBlackColor] normalCorlor:[UIColor colorF2F2TextWhiteColor]];
    [self.identtifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(-KSIphonScreenH(50));
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(23));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(23));
        make.height.equalTo(@55);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    self.identtifyBtn.layer.cornerRadius = 10/2;
    self.identtifyBtn.layer.masksToBounds = YES;
    self.identtifyBtn.layer.borderWidth  = 1;
    self.identtifyBtn.layer.borderColor  = [UIColor colorBlueTextColor].CGColor;
    
    self.inquireBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.inquireBtn];
    [self.inquireBtn setTitle:@"记录现场" forState:UIControlStateNormal];
    [self.inquireBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    self.inquireBtn.titleLabel.font = BFont(16);
    [self.inquireBtn setBackgroundImage:[UIImage imageChangeName:@"cxjg_btn_nor"] forState:UIControlStateNormal];
    [self.inquireBtn setBackgroundImage:[UIImage imageChangeName:@"cxjg_btn_sel"] forState:UIControlStateHighlighted];
    [self.inquireBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.identtifyBtn.mas_top).offset(-KSIphonScreenH(20));
        make.left.equalTo(weakSelf.identtifyBtn.mas_left);
        make.width.height.equalTo(weakSelf.identtifyBtn);
        make.centerX.equalTo(weakSelf.identtifyBtn.mas_centerX);
    }];
    self.inquireBtn.layer.shadowOffset = CGSizeMake(0, 5);
    if (KTargetPerson_CS) {
        self.inquireBtn.layer.shadowColor = [UIColor colorBlueTextColor].CGColor;
    }else{
       self.inquireBtn.layer.shadowColor = [UIColor colorWithHexString:@"#0022b4"].CGColor;
    }
    self.inquireBtn.layer.shadowRadius = 3;
    self.inquireBtn.layer.shadowOpacity = 0.35;
    self.inquireBtn.layer.masksToBounds = NO;
}

@end
