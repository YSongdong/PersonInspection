//
//  YWTRecognResultIDCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/19.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTRecognResultIDCell.h"

@implementation YWTRecognResultIDCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    WS(weakSelf);
    self.backgroundColor = [UIColor clearColor];
    
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor clearColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(weakSelf);
//        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
//        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(12));
    }];
    
    self.lineView = [[UIView alloc]init];
    [bgView addSubview:self.lineView];
    self.lineView.backgroundColor = [UIColor colorLineCommonTextColor];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(KSIphonScreenW(12));
        make.right.equalTo(bgView).offset(-KSIphonScreenW(12));
        make.bottom.equalTo(bgView);
        make.height.equalTo(@1);
    }];
    self.lineView.hidden = YES;
    
    UIImageView *rightImageV = [[UIImageView alloc]init];
    [bgView addSubview:rightImageV];
    rightImageV.image = [UIImage imageNamed:@"ico_grzx_enter"];
    rightImageV.contentMode = UIViewContentModeScaleAspectFit;
    [rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.lineView.mas_right);
        make.centerY.equalTo(bgView.mas_centerY);
        make.width.equalTo(@30);
    }];
    
    self.baseTitleLab = [[UILabel alloc]init];
    [bgView addSubview:self.baseTitleLab];
    self.baseTitleLab.text = @"";
    self.baseTitleLab.textColor = [UIColor colorNamlCommonTextColor];
    self.baseTitleLab.font = Font(16);
    [self.baseTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(KSIphonScreenW(12));
        make.centerY.equalTo(bgView.mas_centerY);
        make.width.equalTo(@66);
    }];
    
    self.baseSubTiltlLab = [[UILabel alloc]init];
    [bgView addSubview:self.baseSubTiltlLab];
    self.baseSubTiltlLab.text = @"";
    self.baseSubTiltlLab.textColor = [UIColor colorNamlCommon98TextColor];
    self.baseSubTiltlLab.font = Font(15);
    self.baseSubTiltlLab.textAlignment = NSTextAlignmentRight;
    [self.baseSubTiltlLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightImageV.mas_left).offset(-KSIphonScreenW(5));
        // 最大宽度约束
        make.width.lessThanOrEqualTo(@(KSIphonScreenW(200)));
        make.centerY.equalTo(bgView.mas_centerY);
    }];
}
// 适配深色模式
-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    if (@available(iOS 13.0, *)) {
        if (previousTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            // 不是深色模式
            self.backgroundColor = [UIColor  colorTextWhiteColor];
        }else{
            // 深色模式
            self.backgroundColor = [UIColor colorWithHexString:@"#1e2838"];
        }
    } else {
        self.backgroundColor = [UIColor colorTextWhiteColor];
    }
}

-(void)setFrame:(CGRect)frame{
    frame.origin.x = KSIphonScreenW(12);
    frame.size.width -=KSIphonScreenW(24);
    [super setFrame:frame];
   
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
