//
//  YWTSearchResultStatuCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/14.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTSearchResultStatuCell.h"

@interface YWTSearchResultStatuCell ()

@property (nonatomic,strong) UIView *statuBgView;

@property (nonatomic,strong) UIImageView *statuImageV;

@property (nonatomic,strong) UILabel *statuPromptLab;

@end

@implementation YWTSearchResultStatuCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createStatuView];
    }
    return self;
}
-(void) createStatuView{
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
    self.statuImageV.image = [UIImage imageChangeName:@"jlxc_ico_tips_01"];
    self.statuImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.statuImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.statuBgView).offset(KSIphonScreenW(12));
        make.centerY.equalTo(weakSelf.statuBgView.mas_centerY);
    }];
    
    self.statuPromptLab = [[UILabel alloc]init];
    [self.statuBgView addSubview:self.statuPromptLab];
    self.statuPromptLab.text = @"";
    self.statuPromptLab.textColor = [UIColor colorWithHexString:@"#ff0000"];
    self.statuPromptLab.font = Font(12);
    [self.statuPromptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.statuImageV.mas_right).offset(KSIphonScreenW(7));
        make.centerY.equalTo(weakSelf.statuImageV.mas_centerY);
    }];
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    // 提示信息
    self.statuPromptLab.text = [NSString stringWithFormat:@"%@",dict[@"message"]];
    // 状态  状态:1-正常;2-异常 ,
    NSString *statuStr = [NSString stringWithFormat:@"%@",dict[@"status"]];
    if ([statuStr isEqualToString:@"1"]) {
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
    }else{
        self.statuPromptLab.textColor = [UIColor colorWithHexString:@"#ff0000"];
        self.statuBgView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorWithHexString:@"#1e2838"] normalCorlor:[UIColor colorWithHexString:@"#ffe2e2"]];
        self.statuBgView.layer.borderColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorWithHexString:@"#404856"] normalCorlor:[UIColor colorWithHexString:@"#ffbfbf"]].CGColor;
        self.statuImageV.image = [UIImage imageNamed:@"jlxc_ico_tips_01"];
    }
}
// 适配深色模式
-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    // 状态  状态:1-正常;2-异常 ,
    NSString *statuStr = [NSString stringWithFormat:@"%@",self.dict[@"status"]];
    if (@available(iOS 13.0, *)) {
        if (previousTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            // 不是深色模式
            if ([statuStr isEqualToString:@"1"]) {
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
        }else{
            self.statuBgView.backgroundColor = [UIColor colorViewShallowDarkBlackColor];
            self.statuBgView.layer.borderColor = [UIColor colorWithHexString:@"#404856"].CGColor;
        }
    } else {
        if ([statuStr isEqualToString:@"1"]) {
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
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
