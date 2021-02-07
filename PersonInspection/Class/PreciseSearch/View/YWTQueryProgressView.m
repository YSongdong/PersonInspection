//
//  YWTQueryProgressView.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/12.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTQueryProgressView.h"

@implementation YWTQueryProgressView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createProgressView];
    }
    return self;
}
-(void) createProgressView{
     WS(weakSelf);
    
    UIView *bottomLayerLineView = [[UIView alloc]init];
    [self addSubview:bottomLayerLineView];
    bottomLayerLineView.backgroundColor = [UIColor colorWithHexString:@"#30343d"];
    [bottomLayerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(weakSelf).offset(KSNaviTopHeight-2);
       make.left.right.equalTo(weakSelf);
       make.height.equalTo(@4);
    }];
   
    CGFloat leftW = KScreenW/3;
   
    // 采集人脸背景view
    self.faceBgView = [[UIView alloc]init];
    [self addSubview:self.faceBgView];
    self.faceBgView.backgroundColor = [[UIColor colorBlueTextColor] colorWithAlphaComponent:0.35];
    [self.faceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(weakSelf).offset((leftW-30));
       make.width.height.equalTo(@35);
       make.centerY.equalTo(bottomLayerLineView.mas_centerY);
    }];
    self.faceBgView.layer.cornerRadius = 35/2;
    self.faceBgView.layer.masksToBounds = YES;
   
    // 核实证件背景
    self.idBgView = [[UIView alloc]init];
    [self addSubview:self.idBgView];
    self.idBgView.backgroundColor = [[UIColor colorWithHexString:@"#e3e3e3"] colorWithAlphaComponent:0.35];
    [self.idBgView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(weakSelf).offset(leftW*2);
       make.width.height.equalTo(@35);
       make.centerY.equalTo(bottomLayerLineView.mas_centerY);
    }];
    self.idBgView.layer.cornerRadius = 35/2;
    self.idBgView.layer.masksToBounds = YES;
   
    // 进度背景view
    self.progressBgView = [[UIView alloc]init];
    [self addSubview:self.progressBgView];
    self.progressBgView.backgroundColor = [UIColor colorBlueTextColor];
    [self.progressBgView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(weakSelf).offset(KSNaviTopHeight-2);
       make.left.equalTo(weakSelf);
       make.height.equalTo(@4);
       make.right.equalTo(weakSelf.faceBgView.mas_left).offset(KSIphonScreenW(10));
    }];
   
    // 采集人脸背景imageV
    self.faceBgImageV = [[UIImageView  alloc]init];
    [self addSubview:self.faceBgImageV];
    self.faceBgImageV.image = [UIImage imageChangeName:@"cjrl_pic_01"];
    [self.faceBgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(weakSelf.faceBgView.mas_centerY);
       make.centerX.equalTo(weakSelf.faceBgView.mas_centerX);
    }];
   
    self.faceLab = [[UILabel alloc]init];
    [self addSubview:self.faceLab];
    self.faceLab.text  = @"采集人脸";
    self.faceLab.textColor = [UIColor colorBlueTextColor];
    self.faceLab.font = Font(14);
    [self.faceLab mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(weakSelf.faceBgView.mas_bottom).offset(KSIphonScreenH(10));
       make.centerX.equalTo(weakSelf.faceBgView.mas_centerX);
    }];
   
    // 核实证件背景imageV
    self.idBgImageV = [[UIImageView  alloc]init];
    [self addSubview:self.idBgImageV];
    self.idBgImageV.image = [UIImage imageNamed:@"cjrl_pic_03"];
    [self.idBgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(weakSelf.idBgView.mas_centerY);
       make.centerX.equalTo(weakSelf.idBgView.mas_centerX);
    }];
  
    self.idLab = [[UILabel alloc]init];
    [self addSubview:self.idLab];
    self.idLab.text  = @"核实证件";
    self.idLab.textColor = [UIColor colorWithHexString:@"#e3e3e3"];
    self.idLab.font = Font(14);
    [self.idLab mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(weakSelf.idBgView.mas_bottom).offset(KSIphonScreenH(10));
       make.centerX.equalTo(weakSelf.idBgView.mas_centerX);
    }];
}

-(void)setIsQuickSearch:(BOOL)isQuickSearch{
    _isQuickSearch =  isQuickSearch;
    WS(weakSelf);
    if (isQuickSearch) {
        // 隐藏采集人脸背景view
        self.faceBgView.hidden = YES;
        // 隐藏
        self.faceBgImageV.hidden = YES;
        self.faceLab.hidden = YES;
        
        //
        self.idBgView.backgroundColor = [[UIColor colorBlueTextColor] colorWithAlphaComponent:0.35];
        [self.idBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(KScreenW/2-30/2);
        }];
        self.idBgImageV.image = [UIImage imageChangeName:@"cjrl_pic_01"];
        self.idLab.textColor = [UIColor colorBlueTextColor];
        
        [self.progressBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(KSNaviTopHeight-2);
            make.left.equalTo(weakSelf);
            make.height.equalTo(@4);
            make.right.equalTo(weakSelf.idBgView.mas_left).offset(KSIphonScreenW(10));
        }];
    }
}

// 通过人脸，验证证件
-(void) passFaceVerifiId{
    self.faceBgImageV.image = [UIImage imageChangeName:@"cjrl_pic_02"];
    
    self.idBgImageV.image = [UIImage imageChangeName:@"cjrl_pic_01"];
    self.idBgView.backgroundColor = [[UIColor colorBlueTextColor] colorWithAlphaComponent:0.35];
    self.idLab.textColor = [UIColor colorBlueTextColor];
    WS(weakSelf);
    [self.progressBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(KSNaviTopHeight-2);
        make.left.equalTo(weakSelf);
        make.height.equalTo(@4);
        make.right.equalTo(weakSelf.idBgView.mas_left).offset(KSIphonScreenW(10));
    }];
}




@end
