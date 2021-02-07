//
//  YWTRecrodDetailCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/18.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTRecrodDetailCell.h"

@implementation YWTRecrodDetailCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    
    UIView *bgView =[[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor =  [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorViewShallowerDarkBlackColor] normalCorlor:[UIColor colorTextWhiteColor]];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(KSIphonScreenH(3));
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(12));
        make.bottom.equalTo(weakSelf).offset(-KSIphonScreenH(12));
    }];
    bgView.layer.shadowOffset = CGSizeMake(1, 1);
    bgView.layer.shadowColor = [UIColor colorWithHexString:@"#000000"].CGColor;
    bgView.layer.shadowRadius = 3;
    bgView.layer.shadowOpacity = 0.10;
    bgView.layer.cornerRadius = 10/2;
    
    self.detailLab = [[UILabel alloc]init];
    [bgView addSubview:self.detailLab];
    self.detailLab.text = @"";
    self.detailLab.textColor = [UIColor colorNamlCommonTextColor];
    self.detailLab.font = Font(13);
    self.detailLab.numberOfLines = 0;
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(KSIphonScreenH(12));
        make.left.equalTo(bgView).offset(KSIphonScreenW(12));
        make.right.equalTo(bgView).offset(-KSIphonScreenW(12));
    }];
}




@end
