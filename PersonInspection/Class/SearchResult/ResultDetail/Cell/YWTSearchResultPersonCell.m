//
//  YWTResultPersonCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/14.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTSearchResultPersonCell.h"

@interface YWTSearchResultPersonCell ()
@property (nonatomic,strong) UIView *bigBgView;

@property (nonatomic,strong) UIView *userInfoView;
@property (nonatomic,strong) UIImageView *addressImageV;
// 头像
@property (nonatomic,strong) UIImageView *headerImageV;
// 姓名
@property (nonatomic,strong) UILabel *personNameLab;
// 性别
@property (nonatomic,strong) UIImageView *personSexImageV;
// 日期
@property (nonatomic,strong) UILabel *personTimeLab;
// 证件号码
@property (nonatomic,strong) UILabel *idNumberLab;
// 地址
@property (nonatomic,strong) UILabel *addressLab;
// 状态
@property (nonatomic,strong) UIImageView *statuIamgeV;

@end

@implementation YWTSearchResultPersonCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createStatuView];
    }
    return self;
}
-(void) createStatuView{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
    
    self.bigBgView = [[UIView alloc]init];
    [self addSubview:self.bigBgView];
    self.bigBgView.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    [self.bigBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(KSIphonScreenH(7));
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(12));
        make.bottom.equalTo(weakSelf);
    }];
    self.bigBgView.layer.cornerRadius = 10/2;
    self.bigBgView.layer.masksToBounds = YES;
    self.bigBgView.layer.borderWidth = 1;
    self.bigBgView.layer.borderColor = [UIColor colorLineCommonTextColor].CGColor;

    UIView *promptBgView = [[UIView alloc]init];
    [self.bigBgView addSubview:promptBgView];
    promptBgView.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    [promptBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.bigBgView);
        make.height.equalTo(@40);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    [promptBgView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorLineCommonTextColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(promptBgView).offset(KSIphonScreenW(12));
        make.right.equalTo(promptBgView).offset(-KSIphonScreenW(12));
        make.bottom.equalTo(promptBgView);
        make.height.equalTo(@1);
    }];
    
    UIView *promptLineView = [[UIView alloc]init];
    [promptBgView addSubview:promptLineView];
    promptLineView.backgroundColor = [UIColor colorBlueTextColor];
    [promptLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(promptBgView).offset(KSIphonScreenW(12));
        make.width.equalTo(@2);
        make.height.equalTo(@11);
        make.centerY.equalTo(promptBgView.mas_centerY);
    }];
    
    UILabel *promptLab = [[UILabel alloc]init];
    [promptBgView addSubview:promptLab];
    promptLab.text = @"人员身份信息";
    promptLab.textColor = [UIColor colorNamlCommonTextColor];
    promptLab.font = BFont(12);
    [promptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(promptLineView.mas_right).offset(KSIphonScreenW(4));
        make.centerY.equalTo(promptLineView.mas_centerY);
    }];
    
    UIView *personBgView = [[UIView alloc]init];
    [self.bigBgView addSubview:personBgView];
    [personBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptBgView.mas_bottom);
        make.left.right.bottom.equalTo(weakSelf.bigBgView);
    }];
    
    self.headerImageV = [[UIImageView alloc]init];
    [personBgView addSubview:self.headerImageV];
    self.headerImageV.image = [UIImage imageNamed:@"cbl_pic_user"];
    [self.headerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(personBgView).offset(KSIphonScreenW(12));
        make.width.height.equalTo(@(KSIphonScreenH(80)));
        make.centerY.equalTo(personBgView.mas_centerY);
    }];
    self.headerImageV.layer.cornerRadius = KSIphonScreenH(80)/2;
    self.headerImageV.layer.masksToBounds = YES;
    self.headerImageV.layer.borderWidth = 1;
    self.headerImageV.layer.borderColor = [UIColor colorLineCommonTextColor].CGColor;
   
    self.userInfoView = [[UIView alloc]init];
    [personBgView addSubview:self.userInfoView];

    // 姓名
    self.personNameLab = [[UILabel alloc]init];
    [self.userInfoView addSubview:self.personNameLab];
    self.personNameLab.text = @"";
    self.personNameLab.textColor = [UIColor colorNamlCommonTextColor];
    self.personNameLab.font = BFont(19);
    [self.personNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.userInfoView);
    }];
    
    // 性别
    self.personSexImageV = [[UIImageView alloc]init];
    [self.userInfoView addSubview:self.personSexImageV];
    self.personSexImageV.image = [UIImage imageNamed:@"cxjg_ico_xb01"];
    self.personSexImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.personSexImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.personNameLab.mas_right).offset(KSIphonScreenW(5));
        make.bottom.equalTo(weakSelf.personNameLab.mas_bottom);
    }];
    
    // 日期
    self.personTimeLab = [[UILabel alloc]init];
    [self.userInfoView addSubview:self.personTimeLab];
    self.personTimeLab.text = @"";
    self.personTimeLab.textColor = [UIColor colorNamlCommon65TextColor];
    self.personTimeLab.font = Font(12);
    [self.personTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.personSexImageV.mas_right).offset(KSIphonScreenW(15));
        make.bottom.equalTo(weakSelf.personNameLab.mas_bottom);
    }];
    
    UIImageView *idImageV = [[UIImageView alloc]init];
    [self.userInfoView addSubview:idImageV];
    idImageV.image = [UIImage imageNamed:@"cxjg_ico_zh"];
    idImageV.contentMode = UIViewContentModeScaleAspectFit;
    [idImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.userInfoView);
        make.top.equalTo(weakSelf.personNameLab.mas_bottom).offset(KSIphonScreenH(13));
    }];
    
    // 证件号码
    self.idNumberLab = [[UILabel alloc]init];
    [self.userInfoView addSubview:self.idNumberLab];
    self.idNumberLab.text = @"证号: ";
    self.idNumberLab.textColor = [UIColor colorNamlCommon98TextColor];
    self.idNumberLab.font = Font(13);
    [self.idNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(idImageV.mas_right).offset(KSIphonScreenW(6));
        make.centerY.equalTo(idImageV.mas_centerY);
    }];
    
    self.addressImageV = [[UIImageView alloc]init];
    [self.userInfoView addSubview:self.addressImageV];
    self.addressImageV.image = [UIImage imageNamed:@"cxjg_ico_dz"];
    self.addressImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.addressImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.userInfoView);
        make.top.equalTo(idImageV.mas_bottom).offset(KSIphonScreenH(7));
    }];
    
    // 地址
    self.addressLab = [[UILabel alloc]init];
    [self.userInfoView addSubview:self.addressLab];
    self.addressLab.text = @"";
    self.addressLab.textColor = [UIColor colorNamlCommon98TextColor];
    self.addressLab.font = Font(13);
    self.addressLab.numberOfLines = 2;
    [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.idNumberLab.mas_left);
        make.right.equalTo(weakSelf.userInfoView.mas_right).offset(-KSIphonScreenW(5));
        make.top.equalTo(weakSelf.addressImageV.mas_top);
    }];
    
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.personNameLab.mas_top);
        make.left.equalTo(weakSelf.headerImageV.mas_right).offset(KSIphonScreenW(12));
        make.right.equalTo(personBgView.mas_right);
        make.bottom.equalTo(weakSelf.addressLab.mas_bottom);
        make.centerY.equalTo(personBgView.mas_centerY);
    }];
    
    // 状态
    self.statuIamgeV = [[UIImageView alloc]init];
    [self.bigBgView addSubview:self.statuIamgeV];
    self.statuIamgeV.image = [UIImage imageNamed:@"cxjg_pic_jgzc"];
    self.statuIamgeV.hidden = YES;
    [self.statuIamgeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bigBgView).offset(1);
        make.right.equalTo(weakSelf.bigBgView).offset(-1);
    }];
}
// 适配深色模式
-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    if (@available(iOS 13.0, *)) {
        if (previousTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            // 不是深色模式
            self.bigBgView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
            self.headerImageV.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
        }else{
            // 深色模式
            self.bigBgView.layer.borderColor = [UIColor colorWithHexString:@"#404856"].CGColor;
            self.headerImageV.layer.borderColor = [UIColor colorWithHexString:@"#404856"].CGColor;
        }
    } else {
        self.bigBgView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
        self.headerImageV.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
    }
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    // 头像
    [YWTTools sd_setImageView:self.headerImageV WithURL:dict[@"face_url"] andPlaceholder:@"cbl_pic_user"];
    // 姓名
    self.personNameLab.text =[NSString stringWithFormat:@"%@",dict[@"name"]];
    // 性别  1男  2女
    NSString *sexStr = [NSString stringWithFormat:@"%@",dict[@"sex"]];
    if ([sexStr isEqualToString:@"男"]) {
        self.personSexImageV.image = [UIImage imageNamed:@"cxjg_ico_xb01"];
    }else{
        self.personSexImageV.image = [UIImage imageNamed:@"cxjg_ico_xb02"];
    }
    // 日期
    NSString *birthdateStr = [NSString stringWithFormat:@"%@",dict[@"birth_date"]];
    if ([birthdateStr isEqualToString:@""] || birthdateStr == nil) {
        self.personTimeLab.hidden = YES;
    }else{
        self.personTimeLab.hidden = NO;
        self.personTimeLab.text = birthdateStr;
    }
    // 证件号码
    self.idNumberLab.text =[NSString stringWithFormat:@"证件: %@",dict[@"id_card"]];
    // 地址
    WS(weakSelf);
    NSString *addressStr = [NSString stringWithFormat:@"%@",dict[@"address"]];
    if ([addressStr isEqualToString:@""] || addressStr == nil) {
        self.addressLab.hidden = YES;
        self.addressImageV.hidden = YES;
        [self.addressLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.idNumberLab.mas_bottom);
        }];
    }else{
        self.addressLab.hidden = NO;
        self.addressImageV.hidden = NO;
        self.addressLab.text = [NSString stringWithFormat:@"地址: %@",dict[@"address"]];
        [self.addressLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.addressLab.mas_bottom);
        }];
    }
    // 状态   0-查无此证;1-正常；2-异常;3-身份证异常 ,
    NSString *resultStatusStr = [NSString stringWithFormat:@"%@",dict[@"result_status"]];
    if ([resultStatusStr isEqualToString:@"1"]) {
        self.statuIamgeV.image = [UIImage imageNamed:@"cxjg_pic_jgzc"];
        self.statuIamgeV.hidden = YES;
    }else if([resultStatusStr isEqualToString:@"3"]){
        self.statuIamgeV.image = [UIImage imageNamed:@"cxjg_pic_yzyc"];
        self.statuIamgeV.hidden = NO;
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
