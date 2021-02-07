//
//  YWTRecordBaseView.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/18.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTRecordBaseView.h"

@implementation YWTRecordBaseView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =  [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    WS(weakSelf);
    self.backgroundColor = [UIColor clearColor];
    
    self.lineView = [[UIView alloc]init];
    [self addSubview:self.lineView];
    self.lineView.backgroundColor = [UIColor colorLineCommonTextColor];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    self.baseSubTiltlLab.numberOfLines = 2;
    self.baseSubTiltlLab.textAlignment = NSTextAlignmentRight;
    [self.baseSubTiltlLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(12));
        // 最大宽度约束
        make.width.lessThanOrEqualTo(@(KSIphonScreenW(240)));
        make.top.equalTo(weakSelf.baseTitleLab.mas_top);
    }];
}

@end
