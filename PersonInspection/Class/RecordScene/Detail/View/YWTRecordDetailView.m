//
//  YWTRecordDetailView.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/18.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTRecordDetailView.h"

@implementation YWTRecordDetailView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    
    UIView *lineView =[[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorBlueTextColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.width.equalTo(@2);
        make.height.equalTo(@14);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    self.detailLab = [[UILabel alloc]init];
    [self addSubview:self.detailLab];
    self.detailLab.text = @"";
    self.detailLab.textColor = [UIColor colorNamlCommonTextColor];
    self.detailLab.font = BFont(14);
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(KSIphonScreenW(7));
        make.centerY.equalTo(lineView.mas_centerY);
    }];
}




@end
