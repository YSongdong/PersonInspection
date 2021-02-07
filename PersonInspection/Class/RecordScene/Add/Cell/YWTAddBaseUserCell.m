//
//  YWTAddBaseUserCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/16.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTAddBaseUserCell.h"

@implementation YWTAddBaseUserCell
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
    
    self.baseTitleLab = [[UILabel alloc]init];
    [self addSubview:self.baseTitleLab];
    self.baseTitleLab.text = @"";
    self.baseTitleLab.textColor = [UIColor colorWithHexString:@"#b4b4b4"];
    self.baseTitleLab.font = Font(16);
    [self.baseTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    self.baseSubTiltlLab = [[UILabel alloc]init];
    [self addSubview:self.baseSubTiltlLab];
    self.baseSubTiltlLab.text = @"";
    self.baseSubTiltlLab.textColor = [UIColor colorWithHexString:@"#c9c9c9"];
    self.baseSubTiltlLab.font = Font(16);
    self.baseSubTiltlLab.textAlignment = NSTextAlignmentRight;
    [self.baseSubTiltlLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineView.mas_right);
        // 最大宽度约束
        make.width.lessThanOrEqualTo(@(KSIphonScreenW(260)));
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
}

-(void)setModel:(YWTAddRecordModel *)model{
    _model = model;
    
    self.baseTitleLab.text = model.titleStr;
    
    self.baseSubTiltlLab.text = model.subTitleStr;
}




@end
