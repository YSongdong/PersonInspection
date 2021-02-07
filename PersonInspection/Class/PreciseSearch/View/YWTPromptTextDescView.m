//
//  YWTPromptTextDescView.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/13.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTPromptTextDescView.h"

@implementation YWTPromptTextDescView

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
       self.backgroundColor = [UIColor colorWithHexString:@"#1b1f29"];
    }
    self.layer.cornerRadius = 10/2;
    self.layer.masksToBounds = YES;
    
    UIView *circleView = [[UIView alloc]init];
    [self addSubview:circleView];
    circleView.backgroundColor = [UIColor colorBlueTextColor];
    [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(17));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.height.equalTo(@8);
    }];
    circleView.layer.cornerRadius = 8/2;
    circleView.layer.masksToBounds = YES;
    
    self.promptTextLab = [[UILabel alloc]init];
    [self addSubview:self.promptTextLab];
    self.promptTextLab.text = @"";
    if (KTargetPerson_CS) {
        self.promptTextLab.textColor = [UIColor colorNamlCommon98TextColor];
    }else{
        self.promptTextLab.textColor = [UIColor colorWithHexString:@"#8d99b6"];
    }
    self.promptTextLab.font = Font(12);
    [self.promptTextLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(circleView.mas_right).offset(KSIphonScreenW(7));
        make.centerY.equalTo(circleView.mas_centerY);
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(3));
    }];
}

@end
