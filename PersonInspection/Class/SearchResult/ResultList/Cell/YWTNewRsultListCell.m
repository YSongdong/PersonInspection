//
//  YWTNewRsultListCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/7/6.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTNewRsultListCell.h"

@interface YWTNewRsultListCell ()

@property (nonatomic,strong) UIView *bgView;
// 状态view
@property (nonatomic,strong) UIView *statuView;
// 姓名
@property (nonatomic,strong) UILabel *nameLab;
// 工作类别
@property (nonatomic,strong) UILabel *jobCategoryLab;
// 状态imageV
@property (nonatomic,strong) UIImageView *statuImageV;
// 证件号
@property (nonatomic,strong) UILabel *idNumberLab;
// 来源
@property (nonatomic,strong) UILabel *sourceLab;
// 错误说明
@property (nonatomic,strong) UILabel *errorMarkLab;
// 时间
@property (nonatomic,strong) UILabel *timeLab;
// 人脸照片
@property (nonatomic,strong) UIImageView *facePhotoImageV;
// 证件照片
@property (nonatomic,strong) UIImageView *idPhotoImageV;
//// 解绑按钮
//@property (nonatomic,strong) UIButton *unbundBTn;

@end


@implementation YWTNewRsultListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createListCell];
    }
    return self;
}
-(void) createListCell{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
    
    self.bgView = [[UIView alloc]init];
    [self.contentView addSubview:self.bgView];
    self.bgView.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(KSIphonScreenH(5));
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.bottom.equalTo(weakSelf).offset(-KSIphonScreenH(5));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(12));
    }];
    self.bgView.layer.cornerRadius = 10/2;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [UIColor colorLineCommonTextColor].CGColor;
    UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCell:)];
    [self.bgView addGestureRecognizer:cellTap];
    
    UIView *statuBgView = [[UIView alloc]init];
    [self.bgView addSubview:statuBgView];
    [statuBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.bgView);
        make.height.equalTo(@(KSIphonScreenH(45)));
    }];
    
    self.statuView = [[UIView alloc]init];
    [statuBgView addSubview:self.statuView];
    self.statuView.backgroundColor = [UIColor colorWithHexString:@"#3675fc"];
    [self.statuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(statuBgView);
        make.width.equalTo(@3);
        make.height.equalTo(@(KSIphonScreenH(21)));
        make.centerY.equalTo(statuBgView.mas_centerY);
    }];
    
    // 姓名
    self.nameLab = [[UILabel alloc]init];
    [statuBgView addSubview:self.nameLab];
    self.nameLab.textColor = [UIColor colorNamlCommonTextColor];
    self.nameLab.font =BFont(16);
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.statuView.mas_right).offset(KSIphonScreenW(12));
        make.centerY.equalTo(statuBgView.mas_centerY);
    }];
    
    
    // 来源
    self.sourceLab = [[UILabel alloc]init];
    [statuBgView addSubview:self.sourceLab];
    self.sourceLab.textColor = [UIColor colorNamlCommon65TextColor];
    self.sourceLab.font = BFont(16);
    [self.sourceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab.mas_right).offset(KSIphonScreenW(2));
        make.centerY.equalTo(weakSelf.nameLab.mas_centerY);
    }];
    
    // 状态imageV
    self.statuImageV = [[UIImageView alloc]init];
    [statuBgView addSubview:self.statuImageV];
    self.statuImageV.image = [UIImage  imageNamed:@"cxjl_ico_zc"];
    self.statuImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.statuImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(statuBgView).offset(-KSIphonScreenW(12));
         make.centerY.equalTo(statuBgView.mas_centerY);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    [statuBgView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorViewShallowerDarkBlackColor] normalCorlor:[UIColor colorWithHexString:@"#e3e3e3"]];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab.mas_left);
        make.right.equalTo(self.statuImageV.mas_right);
        make.bottom.equalTo(statuBgView);
        make.height.equalTo(@1);
    }];
    
    // 证件号
    self.idNumberLab = [[UILabel alloc]init];
    [self.bgView addSubview:self.idNumberLab];
    self.idNumberLab.textColor = [UIColor colorNamlCommon65TextColor];
    self.idNumberLab.font = BFont(13);
    [self.idNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(KSIphonScreenH(15));
        make.left.equalTo(weakSelf.nameLab.mas_left);
    }];
    
    // 工作类别
    self.jobCategoryLab = [[UILabel alloc]init];
    [self.bgView addSubview:self.jobCategoryLab];
    self.jobCategoryLab.textColor = [UIColor colorWithHexString:@"#b8b8b8"];
    self.jobCategoryLab.font =Font(12);
    [self.jobCategoryLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.idNumberLab.mas_bottom).offset(KSIphonScreenH(5));
        make.left.equalTo(weakSelf.idNumberLab.mas_left);
    }];

    // 错误说明
    self.errorMarkLab = [[UILabel alloc]init];
    [self.bgView addSubview:self.errorMarkLab];
    self.errorMarkLab.textColor = [UIColor colorWithHexString:@"#ff1013"];
    self.errorMarkLab.font = BFont(13);
    [self.errorMarkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView.mas_right).offset(-KSIphonScreenH(15));
        make.centerY.equalTo(weakSelf.idNumberLab.mas_centerY);
    }];
    
    // 时间
    self.timeLab = [[UILabel alloc]init];
    [self.bgView addSubview:self.timeLab];
    self.timeLab.textColor = [UIColor colorWithHexString:@"#b8b8b8"];
    self.timeLab.font = Font(12);
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.errorMarkLab.mas_right);
        make.centerY.equalTo(weakSelf.jobCategoryLab.mas_centerY);
    }];
    
    // 人脸照片
    self.facePhotoImageV = [[UIImageView alloc]init];
    [self.bgView addSubview:self.facePhotoImageV];
    self.facePhotoImageV.image = [UIImage imageNamed:@"cxjl_pic_jzsb"];
    self.facePhotoImageV.userInteractionEnabled = YES;
    self.facePhotoImageV.tag = 2000;
    self.facePhotoImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.facePhotoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.jobCategoryLab.mas_bottom).offset(KSIphonScreenH(5));
        make.left.equalTo(weakSelf.idNumberLab.mas_left);
        make.height.width.equalTo(@(KSIphonScreenH(60)));
    }];
    self.facePhotoImageV.layer.cornerRadius = KSIphonScreenH(60)/2;
    self.facePhotoImageV.layer.masksToBounds = YES;
    self.facePhotoImageV.layer.borderWidth = 1;
    self.facePhotoImageV.layer.borderColor = [UIColor colorWithHexString:@"#ebebeb"].CGColor;
    self.facePhotoImageV.hidden = YES;
    UITapGestureRecognizer *faceTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTap:)];
    [self.facePhotoImageV addGestureRecognizer:faceTap];
    
    // 证件照片
    self.idPhotoImageV = [[UIImageView alloc]init];
    [self.bgView addSubview:self.idPhotoImageV];
    self.idPhotoImageV.image = [UIImage imageNamed:@"cxjl_pic_zj"];
    self.idPhotoImageV.userInteractionEnabled = YES;
    self.idPhotoImageV.tag = 2001;
    self.idPhotoImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.idPhotoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.facePhotoImageV.mas_right).offset(KSIphonScreenW(12));
        make.height.width.equalTo(weakSelf.facePhotoImageV);
        make.centerY.equalTo(weakSelf.facePhotoImageV.mas_centerY);
    }];
    self.idPhotoImageV.layer.cornerRadius = KSIphonScreenH(60)/2;
    self.idPhotoImageV.layer.masksToBounds = YES;
    self.idPhotoImageV.layer.borderWidth = 1;
    self.idPhotoImageV.layer.borderColor = [UIColor colorWithHexString:@"#ebebeb"].CGColor;
    self.idPhotoImageV.hidden = YES;
    UITapGestureRecognizer *idTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTap:)];
    [self.idPhotoImageV addGestureRecognizer:idTap];
    
    // 取消解绑按钮
//    self.unbundBTn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.bgView addSubview:self.unbundBTn];
//    [self.unbundBTn setImage:[UIImage imageNamed:@"list_untie"] forState:UIControlStateNormal];
//    [self.unbundBTn.imageView setContentMode:UIViewContentModeScaleAspectFit];
//    self.unbundBTn.titleLabel.font = Font(14);
//    [self.unbundBTn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(weakSelf.bgView);
//        make.centerY.equalTo(weakSelf.idPhotoImageV.mas_centerY);
//        make.width.equalTo(@80);
//        make.height.equalTo(@30);
//    }];
//    [self.unbundBTn addTarget:self action:@selector(selectUnbundBtn:) forControlEvents:UIControlEventTouchUpInside];
//    self.unbundBTn.hidden = YES;
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    // 姓名
    self.nameLab.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
    // 来源
    self.sourceLab.text = [NSString stringWithFormat:@"/%@",dict[@"source"]];
    // 证件号
    self.idNumberLab.text = [NSString stringWithFormat:@"%@",dict[@"certificate_num"]];
    // 时间
    self.timeLab.text = [NSString stringWithFormat:@"%@",dict[@"query_time"]];
    // 错误说明
    self.errorMarkLab.text = [NSString stringWithFormat:@"%@",dict[@"message"]];
    // 类别
    self.jobCategoryLab.text = [NSString stringWithFormat:@"%@",dict[@"certificate_type"]];
    
    NSString *statusStr = [NSString stringWithFormat:@"%@",dict[@"status"]];
    // 状态:1-正常,2-异常,3-过期
    if ([statusStr isEqualToString:@"1"]) {
        // 正常
        self.statuView.backgroundColor =  [UIColor colorWithHexString:@"#00796a"];
        self.statuImageV.image = [UIImage  imageNamed:@"cxjl_ico_zc"];
        
        self.errorMarkLab.textColor = [UIColor colorBlueTextColor];
    }else{
        self.statuView.backgroundColor =  [UIColor colorWithHexString:@"#ff1013"];
        self.statuImageV.image = [UIImage  imageNamed:@"cxjl_ico_yc"];
        
        self.errorMarkLab.textColor =  [UIColor colorWithHexString:@"#ff1013"];
    }
    
    // 人脸照片
    if (![dict[@"face_url"] isEqualToString:@""]) {
        self.facePhotoImageV.hidden = NO;
        [YWTTools sd_setImageView:self.facePhotoImageV WithURL:dict[@"face_url"] andPlaceholder:@"cxjl_pic_jzsb"];
    }else{
        self.facePhotoImageV.hidden = YES;
    }
    // 证件照片
    if (![dict[@"certificate_url"] isEqualToString:@""]) {
        self.idPhotoImageV.hidden = NO;
        [YWTTools sd_setImageView:self.idPhotoImageV WithURL:dict[@"certificate_url"] andPlaceholder:@"cxjl_pic_zj"];
    }else{
        self.idPhotoImageV.hidden = YES;
    }
     
//    if ([statusStr isEqualToString:@"1"] && ![dict[@"certificate_url"] isEqualToString:@""] && ![dict[@"face_url"] isEqualToString:@""]) {
//        self.unbundBTn.hidden = NO;
//    }else{
//        self.unbundBTn.hidden = YES;
//    }
    
    // 当人像都为空时， 证件修改
    if ([dict[@"face_url"] isEqualToString:@""] && ![dict[@"certificate_url"] isEqualToString:@""]) {
        self.idPhotoImageV.hidden = YES;
        self.facePhotoImageV.hidden = NO;
        [YWTTools sd_setImageView:self.facePhotoImageV WithURL:dict[@"certificate_url"] andPlaceholder:@"cxjl_pic_zj"];
    }
}
// 点击cell
-(void) selectCell:(UITapGestureRecognizer*)tag{
    self.selectCell();
}
-(void)selectTap:(UITapGestureRecognizer*)tapG{
    NSInteger tap = tapG.view.tag - 2000;
    self.selectPic(tap);
}
// 点击解绑按钮
-(void) selectUnbundBtn:(UIButton*)sender{
    self.selectUnbundBtn();
}

// 适配深色模式
-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    if (@available(iOS 13.0, *)) {
        if (previousTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            // 不是深色模式
            self.bgView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
        }else{
            // 深色模式
            self.bgView.layer.borderColor = [UIColor colorWithHexString:@"#404856"].CGColor;
        }
    } else {
        self.bgView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
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
