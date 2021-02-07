//
//  YWTResultPromptView.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/20.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTResultPromptView.h"

@implementation YWTResultPromptView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
    
    self.statuBgView = [[UIView alloc]init];
    [self addSubview:self.statuBgView];
    self.statuBgView.backgroundColor = [UIColor colorWithHexString:@"#ffe2e2"];
    [self.statuBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(KSIphonScreenH(7));
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(12));
        make.bottom.equalTo(weakSelf);
    }];
    self.statuBgView.layer.cornerRadius = 10/2;
    self.statuBgView.layer.masksToBounds = YES;
    self.statuBgView.layer.borderWidth = 1;
    self.statuBgView.layer.borderColor = [UIColor colorWithHexString:@"#ffbfbf"].CGColor;
    self.statuBgView.alpha = 0.9;
    
    self.statuImageV = [[UIImageView alloc]init];
    [self.statuBgView addSubview:self.statuImageV];
    self.statuImageV.image = [UIImage imageNamed:@"jlxc_ico_tips"];
    self.statuImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.statuImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.statuBgView).offset(KSIphonScreenW(12));
        make.centerY.equalTo(weakSelf.statuBgView.mas_centerY);
    }];

    self.statuPromptLab = [[UILabel alloc]init];
    [self.statuBgView addSubview:self.statuPromptLab];
    self.statuPromptLab.text = @"";
    self.statuPromptLab.textColor = [UIColor colorWithHexString:@"#ff0000"];
    self.statuPromptLab.font = BFont(13);
    [self.statuPromptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.statuImageV.mas_right).offset(KSIphonScreenW(7));
        make.centerY.equalTo(weakSelf.statuImageV.mas_centerY);
    }];
}
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    self.statuPromptLab.text = [NSString stringWithFormat:@"%@",dict[@"title"]];
    
    // 0-查无此证;1-正常；2-异常 3身份异常;
    NSString *resultStatusStr = [NSString stringWithFormat:@"%@",dict[@"result_status"]];
    if ([resultStatusStr isEqualToString:@"2"] || [resultStatusStr isEqualToString:@"3"]) {
        //异常
        self.statuImageV.image = [UIImage imageNamed:@"jlxc_ico_tips_01"];
        
        self.statuPromptLab.textColor = [UIColor colorWithHexString:@"#ff0000"];
        self.statuBgView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorViewShallowDarkBlackColor] normalCorlor:[UIColor colorWithHexString:@"#ffe2e2"]];
        self.statuBgView.layer.borderColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorWithHexString:@"#404856"] normalCorlor:[UIColor colorWithHexString:@"#ffbfbf"]].CGColor;
    }else if([resultStatusStr isEqualToString:@"1"]){
        self.statuImageV.image = [UIImage imageChangeName:@"jlxc_ico_tips_02"];
        if (KTargetPerson_CS) {
            self.statuPromptLab.textColor = [UIColor colorWithHexString:@"#00796a"];
            self.statuBgView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorWithHexString:@"#1e2838"] normalCorlor:[UIColor colorWithHexString:@"#d7ece9"]];
            self.statuBgView.layer.borderColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorWithHexString:@"#404856"] normalCorlor:[UIColor colorWithHexString:@"#9dcac4"]].CGColor;
        }else{
            self.statuPromptLab.textColor = [UIColor colorWithHexString:@"#28b04a"];
            self.statuBgView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorWithHexString:@"#1e2838"] normalCorlor:[UIColor colorWithHexString:@"#e1efe7"]];
            self.statuBgView.layer.borderColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorWithHexString:@"#404856"] normalCorlor:[UIColor colorWithHexString:@"#aedcc2"]].CGColor;
        }
    }
}
// 适配深色模式
-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    // 状态  状态:1-正常;2-异常 ,
    NSString *resultStatusStr = [NSString stringWithFormat:@"%@",self.dict[@"result_status"]];
    if (@available(iOS 13.0, *)) {
        if (previousTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
           if ([resultStatusStr isEqualToString:@"2"] || [resultStatusStr isEqualToString:@"3"]) {
               self.statuBgView.backgroundColor = [UIColor colorWithHexString:@"#ffe2e2"];
               self.statuBgView.layer.borderColor = [UIColor colorWithHexString:@"#ffbfbf"].CGColor;
           }
        }else{
            // 不是深色模式
            if ([resultStatusStr isEqualToString:@"1"]) {
                if (KTargetPerson_CS) {
                    self.statuBgView.backgroundColor = [UIColor colorWithHexString:@"#d7ece9"];
                    self.statuBgView.layer.borderColor = [UIColor colorWithHexString:@"#9dcac4"].CGColor;
                }else{
                    self.statuBgView.backgroundColor = [UIColor colorWithHexString:@"#e1efe7"];
                    self.statuBgView.layer.borderColor = [UIColor colorWithHexString:@"#aedcc2"].CGColor;
                }
            }else{
                self.statuBgView.backgroundColor = [UIColor colorWithHexString:@"#ffe2e2"];
                self.statuBgView.layer.borderColor = [UIColor colorWithHexString:@"#ffbfbf"].CGColor;
            }
        }
    } else {
        if ([resultStatusStr isEqualToString:@"2"] || [resultStatusStr isEqualToString:@"3"]) {
            self.statuBgView.backgroundColor = [UIColor colorWithHexString:@"#ffe2e2"];
            self.statuBgView.layer.borderColor = [UIColor colorWithHexString:@"#ffbfbf"].CGColor;
        }else{
            if (KTargetPerson_CS) {
                self.statuBgView.backgroundColor = [UIColor colorWithHexString:@"#d7ece9"];
                self.statuBgView.layer.borderColor = [UIColor colorWithHexString:@"#9dcac4"].CGColor;
            }else{
                self.statuBgView.backgroundColor = [UIColor colorWithHexString:@"#e1efe7"];
                self.statuBgView.layer.borderColor = [UIColor colorWithHexString:@"#aedcc2"].CGColor;
            }
        }
    }
}



@end
