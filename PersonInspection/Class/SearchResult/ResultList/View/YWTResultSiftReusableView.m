//
//  YWTResultSiftReusableView.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/15.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTResultSiftReusableView.h"

@implementation YWTResultSiftReusableView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    
    self.titleNameLab = [[UILabel alloc]init];
    [self addSubview:self.titleNameLab];
    self.titleNameLab.text = @"";
    self.titleNameLab.textColor = [UIColor colorNamlCommonTextColor];
    self.titleNameLab.font = BFont(16);
    [self.titleNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
}
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    self.titleNameLab.text = dict[@"title"];
    
}




@end
