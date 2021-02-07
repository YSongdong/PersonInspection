//
//  YWTResultBottomView.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/14.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTResultBottomView.h"

@implementation YWTResultBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =  [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
    
    self.recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.recordBtn];
    [self.recordBtn setTitle:@"记录现场" forState:UIControlStateNormal];
    [self.recordBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    self.recordBtn.titleLabel.font = BFont(16);
    [self.recordBtn setBackgroundImage:[UIImage imageChangeName:@"cxjg_btn_nor"] forState:UIControlStateNormal];
    [self.recordBtn setBackgroundImage:[UIImage imageChangeName:@"cxjg_btn_sel"] forState:UIControlStateHighlighted];
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(KSIphonScreenH(5));
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.height.equalTo(@55);
    }];
    self.recordBtn.layer.shadowOffset = CGSizeMake(0, 5);
    if (KTargetPerson_CS) {
        self.recordBtn.layer.shadowColor = [UIColor colorBlueTextColor].CGColor;
    }else{
        self.recordBtn.layer.shadowColor = [UIColor colorWithHexString:@"#0022b4"].CGColor;
    }
    self.recordBtn.layer.shadowRadius = 3;
    self.recordBtn.layer.shadowOpacity = 0.35;
    self.recordBtn.layer.masksToBounds = NO;
    [self.recordBtn addTarget:self action:@selector(selectRecordBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.homeBtn];
    [self.homeBtn setTitle:@"回到首页" forState:UIControlStateNormal];
    [self.homeBtn setTitleColor:[UIColor colorBlueTextColor] forState:UIControlStateNormal];
    self.homeBtn.titleLabel.font = BFont(16);
    self.homeBtn.backgroundColor =[UIColor colorStyleLeDarkWithConstantColor:[UIColor colorViewDarkBlackColor] normalCorlor:[UIColor colorF2F2TextWhiteColor]];
    [self.homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.recordBtn.mas_right).offset(KSIphonScreenW(10));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(10));
        make.width.height.equalTo(weakSelf.recordBtn);
        make.centerY.equalTo(weakSelf.recordBtn.mas_centerY);
    }];
    self.homeBtn.layer.cornerRadius = 10/2;
    self.homeBtn.layer.masksToBounds = YES;
    self.homeBtn.layer.borderWidth  = 1;
    self.homeBtn.layer.borderColor  = [UIColor colorBlueTextColor].CGColor;
    [self.homeBtn addTarget:self action:@selector(selectBackBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)selectRecordBtn:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(pushRecordBtn)]) {
        [self.delegate pushRecordBtn];
    }
}
-(void)selectBackBtn:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(pushBackBtn)]) {
           [self.delegate pushBackBtn];
       }
}

-(void)setIsSuccess:(BOOL)isSuccess{
    _isSuccess = isSuccess;
    WS(weakSelf);
    if (isSuccess) {
        self.recordBtn.hidden = YES;
        [self.homeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(KSIphonScreenH(10));
            make.left.equalTo(weakSelf).offset(KSIphonScreenW(10));
            make.right.equalTo(weakSelf).offset(-KSIphonScreenW(10));
            make.bottom.equalTo(weakSelf).offset(-KSIphonScreenH(10));
        }];
    }
}




@end
