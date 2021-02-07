//
//  SDUpdateView.m
//  AgkSafetyControl
//
//  Created by tiao on 2019/1/12.
//  Copyright © 2019年 wutiao. All rights reserved.
//

#import "YWTUpdateView.h"

@interface YWTUpdateView ()




@property (nonatomic,strong) UIButton *clearBtn;
@end

@implementation YWTUpdateView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUpdateView];
    }
    return self;
}
-(void)createUpdateView{
    __weak typeof(self) weakSelf = self;
    
    UIView *backGrounpView = [[UIView alloc]init];
    [self addSubview:backGrounpView];
    backGrounpView.backgroundColor = [UIColor blackColor];
    backGrounpView.alpha = 0.35;
    [backGrounpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
    [backGrounpView addGestureRecognizer:tap];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor colorPlaceholderTextColor];

    UIView *titleView = [[UIView alloc]init];
    [bgView addSubview:titleView];
    titleView.backgroundColor = [UIColor colorTextWhiteColor];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(bgView);
        make.height.equalTo(@(KSIphonScreenH(45)));
    }];

    self.titleLab = [[UILabel alloc]init];
    [titleView addSubview:self.titleLab];
    self.titleLab.text = @"";
    self.titleLab.textColor = [UIColor colorNamlCommonTextColor];
    self.titleLab.font = BFont(17);
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.titleLab  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleView.mas_centerX);
        make.centerY.equalTo(titleView.mas_centerY);
    }];

    UIView *contentView = [[UIView alloc]init];
    [bgView addSubview:contentView];
    contentView.backgroundColor = [UIColor colorTextWhiteColor];

    self.contentLab = [[UILabel alloc]init];
    [contentView addSubview:self.contentLab];
    self.contentLab.text = @"";
    self.contentLab.font = Font(14);
    self.contentLab.textColor = [UIColor colorNamlCommon65TextColor];
    self.contentLab.numberOfLines = 0;
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(KSIphonScreenH(10));
        make.left.equalTo(contentView).offset(KSIphonScreenW(30));
        make.right.equalTo(contentView).offset(-KSIphonScreenW(15));
    }];
    //加行间距
    [YWTTools changeLineSpaceForLabel:self.contentLab WithSpace:6];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom).offset(1);
        make.left.right.equalTo(titleView);
        make.bottom.equalTo(weakSelf.contentLab.mas_bottom).offset(KSIphonScreenH(10));
    }];

    UIView *bottomBtnView = [[UIView alloc]init];
    [bgView addSubview:bottomBtnView];
    bottomBtnView.backgroundColor = [UIColor colorTextWhiteColor];

    UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBtnView addSubview:updateBtn];
    [updateBtn setTitle:@"立即升级" forState:UIControlStateNormal];
    [updateBtn setTitleColor:[UIColor colorBlueTextColor] forState:UIControlStateNormal];
    updateBtn.titleLabel.font = BFont(16);
    [updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(bottomBtnView);
    }];
    [updateBtn addTarget:self action:@selector(selectUpdateBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [bottomBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_bottom).offset(1);
        make.left.right.equalTo(contentView);
        make.height.equalTo(@(KSIphonScreenH(45)));
    }];

    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(45));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(45));
        make.bottom.equalTo(bottomBtnView.mas_bottom);
    }];
    bgView.layer.cornerRadius = 8;
    bgView.layer.masksToBounds = YES;
 
    self.clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.clearBtn];
    [self.clearBtn setImage:[UIImage imageNamed:@"delecteBtn"] forState:UIControlStateNormal];
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.mas_top).offset(-KSIphonScreenH(5));
        make.right.equalTo(bgView.mas_right);
    }];
    [self.clearBtn addTarget:self action:@selector(selectremoreBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)removeView{
    if (_typeStatu != updateTypeForceStatu) {
        [self selectremoreBtn:nil];
    }
}
-(void) selectremoreBtn:(UIButton *) sender{
    [self removeFromSuperview];
}

-(void)selectUpdateBtn:(UIButton *) sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://apps.apple.com/cn/app/%E6%98%93%E4%BB%B6%E6%9F%A5/id1546807044"]];
}
-(void)setTypeStatu:(updateTypeStatu)typeStatu{
    _typeStatu = typeStatu;
    if (typeStatu == updateTypeForceStatu) {
        self.clearBtn.hidden = YES;
    }else{
         self.clearBtn.hidden = NO;
    }
}





@end
