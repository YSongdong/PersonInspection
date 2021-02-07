//
//  YWTAddRecordAddressCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/16.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTAddRecordAddressCell.h"

@implementation YWTAddRecordAddressCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =  [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorLineCommonTextColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(12));
        make.bottom.equalTo(weakSelf);
        make.height.equalTo(@1);
    }];
    
    UIImageView *rightImageV = [[UIImageView alloc]init];
    [self addSubview:rightImageV];
    rightImageV.image = [UIImage imageChangeName:@"sy_ico_dw"];
    rightImageV.contentMode = UIViewContentModeScaleAspectFit;
    [rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineView.mas_right);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.equalTo(@20);
    }];
    
    self.baseTitleLab = [[UILabel alloc]init];
    [self addSubview:self.baseTitleLab];
    self.baseTitleLab.text = @"当前位置";
    self.baseTitleLab.textColor = [UIColor colorNamlCommonTextColor];
    self.baseTitleLab.font = Font(16);
    [self.baseTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.width.equalTo(@75);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    self.baseSubTiltlLab = [[UILabel alloc]init];
    [self addSubview:self.baseSubTiltlLab];
    self.baseSubTiltlLab.text = @"请选择";
    self.baseSubTiltlLab.textColor = [UIColor colorNamlCommon98TextColor];
    self.baseSubTiltlLab.font = Font(15);
    self.baseSubTiltlLab.numberOfLines = 2;
    self.baseSubTiltlLab.textAlignment = NSTextAlignmentRight;
    [self.baseSubTiltlLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightImageV.mas_left);
        make.left.equalTo(weakSelf.baseTitleLab.mas_right).offset(KSIphonScreenW(5));
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
}

-(void)setModel:(YWTAddRecordModel *)model{
    _model = model;
    
    self.baseTitleLab.text =model.titleStr;

    if ([model.subTitleStr isEqualToString:@""]) {
        self.baseSubTiltlLab.text = @"请选择";
        self.baseSubTiltlLab.textColor = [UIColor colorNamlCommon98TextColor];
    }else{
        self.baseSubTiltlLab.text = model.subTitleStr;
        self.baseSubTiltlLab.textColor = [UIColor colorNamlCommonTextColor];
    }
}





@end
