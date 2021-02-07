//
//  YWTBaseIDCellView.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/15.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTBaseIDCellView.h"

@implementation YWTBaseIDCellView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    
    self.lineView =[[ UIView alloc]init];
    [self addSubview:self.lineView];
    self.lineView.backgroundColor = [UIColor colorLineCommonTextColor];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.right.bottom.equalTo(weakSelf);
        make.height.equalTo(@1);
    }];
    
    self.baseTitleLab = [[UILabel alloc]init];
    [self addSubview:self.baseTitleLab];
    self.baseTitleLab.text = @"";
    self.baseTitleLab.textColor = [UIColor colorNamlCommonTextColor];
    self.baseTitleLab.font = Font(12);
    [self.baseTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    
    self.baseSubTitleLab = [[UILabel alloc]init];
    [self addSubview:self.baseSubTitleLab];
    self.baseSubTitleLab.text = @"";
    self.baseSubTitleLab.textColor = [UIColor colorNamlCommon98TextColor];
    self.baseSubTitleLab.font = Font(12);
    self.baseSubTitleLab.textAlignment = NSTextAlignmentRight;
    [self.baseSubTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(12));
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
}




@end
