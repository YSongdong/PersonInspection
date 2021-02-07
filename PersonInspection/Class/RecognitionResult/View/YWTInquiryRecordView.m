//
//  YWTInquiryRecordView.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/7/2.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTInquiryRecordView.h"

@implementation YWTInquiryRecordView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void) createView{
    self.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
    
    WS(weakSelf);
    UILabel *lab = [[UILabel alloc]init];
    [self addSubview:lab];
    lab.text = @"最近查询:";
    lab.font = Font(14);
    lab.textColor = [UIColor colorWithHexString:@"#909090"];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
}


@end
