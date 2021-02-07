//
//  YWTPromptIdentiryView.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/13.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTPromptIdentiryView.h"

@implementation YWTPromptIdentiryView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createProgressView];
    }
    return self;
}
-(void) createProgressView{
    WS(weakSelf);
    if (KTargetPerson_CS) {
        self.backgroundColor = [UIColor color1e1eTextColor];
    }else{
        self.backgroundColor = [UIColor colorWithHexString:@"#263143"];
    }
    self.layer.cornerRadius = 10/2;
    self.layer.masksToBounds = YES;
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [bgView addSubview:self.activityIndicatorView];
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView);
        make.centerY.equalTo(bgView.mas_centerY);
        make.width.height.equalTo(@30);
    }];
    self.activityIndicatorView.color = [UIColor colorTextWhiteColor];
    self.activityIndicatorView.backgroundColor = [UIColor clearColor];
    self.activityIndicatorView.hidesWhenStopped = NO;
  
    self.bgLab = [[UILabel alloc]init];
    [bgView addSubview:self.bgLab];
    self.bgLab.text = @"识别中...";
    self.bgLab.textColor = [UIColor colorTextWhiteColor];
    self.bgLab.font = Font(13);
    [self.bgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.activityIndicatorView.mas_right).offset(KSIphonScreenW(6));
        make.centerY.equalTo(weakSelf.activityIndicatorView.mas_centerY);
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgLab.mas_top);
        make.left.equalTo(weakSelf.activityIndicatorView.mas_left);
        make.right.equalTo(weakSelf.bgLab.mas_right);
        make.bottom.equalTo(weakSelf.bgLab.mas_bottom);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
}

@end
