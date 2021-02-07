//
//  YWTListBlackPageView.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/6/12.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTListBlankPageView.h"

@implementation YWTListBlankPageView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void) createView{
    
    self.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    WS(weakSelf);
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    
    self.bgImageV = [[UIImageView alloc]init];
    [bgView addSubview:self.bgImageV];
    self.bgImageV.image = [UIImage imageNamed:@"cxjl_pic_zwjl"];
    self.bgImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
    self.showMarkLab = [[UILabel alloc]init];
    [bgView addSubview:self.showMarkLab];
    self.showMarkLab.text =@"暂无资源";
    self.showMarkLab.textColor = [UIColor colorNamlCommon65TextColor];
    self.showMarkLab.font = BFont(14);
    [self.showMarkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgImageV.mas_bottom).offset(KSIphonScreenH(22));
        make.centerX.equalTo(weakSelf.bgImageV.mas_centerX);
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgImageV.mas_top);
        make.left.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.showMarkLab.mas_bottom);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
}


@end
