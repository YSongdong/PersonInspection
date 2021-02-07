//
//  YWTSearchResultCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/20.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTSearchResultCell.h"

#import "YWTResultBaseView.h"

@interface YWTSearchResultCell ()

@property (nonatomic,strong) UIView *bgView;
// 姓名
@property (nonatomic,strong) YWTResultBaseView *nameView;
// 性别
@property (nonatomic,strong) YWTResultBaseView *sexView;
// 作业类别
@property (nonatomic,strong) YWTResultBaseView *jobCategoryView;
// 操作项目
@property (nonatomic,strong) YWTResultBaseView *operatItemView;

@property (nonatomic,strong) UIImageView *errorImageV;

@property (nonatomic,strong) UILabel *showErrorLab;
@end


@implementation YWTSearchResultCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createStatuView];
    }
    return self;
}
-(void) createStatuView{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
    
    self.bgView = [[UIView alloc]init];
    [self addSubview:self.bgView];
    self.bgView.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(KSIphonScreenH(3));
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(12));
        make.bottom.equalTo(weakSelf).offset(-KSIphonScreenH(3));
    }];
    self.bgView.layer.cornerRadius = 10/2;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [UIColor colorLineCommonTextColor].CGColor;
    
    // 作业类别
    self.jobCategoryView = [[YWTResultBaseView alloc]init];
    [self.bgView addSubview:self.jobCategoryView];
    self.jobCategoryView.titleLab.text = @"作业类别";
    self.jobCategoryView.lineImageV.hidden = NO;
    self.jobCategoryView.titleLab.font = BFont(14);
    self.jobCategoryView.titleLab.textColor = [UIColor colorNamlCommonTextColor];
    self.jobCategoryView.subTitleLab.font = BFont(14);
    [self.jobCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.bgView);
        make.height.equalTo(@(KSIphonScreenH(40)));
    }];
    
    // 姓名
    self.nameView = [[YWTResultBaseView alloc]init];
    [self.bgView addSubview:self.nameView];
    self.nameView.titleLab.text = @"姓名";
    self.nameView.lineImageV.hidden = NO;
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.jobCategoryView.mas_bottom);
        make.left.equalTo(weakSelf.jobCategoryView.mas_left);
        make.width.equalTo(weakSelf.jobCategoryView);
        make.height.equalTo(@(KSIphonScreenH(35)));
        make.centerX.equalTo(weakSelf.jobCategoryView.mas_centerX);
    }];

    // 性别
    self.sexView = [[YWTResultBaseView alloc]init];
    [self.bgView addSubview:self.sexView];
    self.sexView.titleLab.text = @"性别";
    self.sexView.lineImageV.hidden = NO;
    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameView.mas_bottom);
        make.left.equalTo(weakSelf.nameView.mas_left);
        make.width.equalTo(weakSelf.nameView);
        make.height.equalTo(@(KSIphonScreenH(35)));
        make.centerX.equalTo(weakSelf.nameView.mas_centerX);
    }];

    // 操作项目
    self.operatItemView = [[YWTResultBaseView alloc]init];
    [self.bgView addSubview:self.operatItemView];
    self.operatItemView.titleLab.text = @"操作项目";
    [self.operatItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.sexView.mas_bottom);
        make.left.equalTo(weakSelf.nameView.mas_left);
        make.width.height.equalTo(weakSelf.sexView);
        make.centerX.equalTo(weakSelf.nameView.mas_centerX);
    }];
    
    UIView *detaBgView = [[UIView alloc]init];
    [self.bgView addSubview:detaBgView];
    [detaBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.operatItemView.mas_bottom);
        make.left.right.bottom.equalTo(weakSelf.bgView);
    }];

    UIView *lineView = [[UIView alloc]init];
    [detaBgView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorLineCommonTextColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detaBgView.mas_top);
        make.left.equalTo(detaBgView).offset(KSIphonScreenW(12));
        make.right.equalTo(detaBgView).offset(-KSIphonScreenW(12));
        make.height.equalTo(@1);
    }];
    
    self.errorImageV = [[UIImageView alloc]init];
    [detaBgView addSubview:self.errorImageV];
    self.errorImageV.image = [UIImage imageNamed:@"jlxc_ico_tips_01"];
    self.errorImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.errorImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(detaBgView).offset(KSIphonScreenW(12));
        make.centerY.equalTo(detaBgView.mas_centerY);
    }];
    
    self.showErrorLab = [[UILabel alloc]init];
    [detaBgView addSubview:self.showErrorLab];
    self.showErrorLab.text = @"";
    self.showErrorLab.textColor = [UIColor colorRedTextColor];
    self.showErrorLab.font = Font(12);
    [self.showErrorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.errorImageV.mas_right).offset(KSIphonScreenW(4));
        make.centerY.equalTo(weakSelf.errorImageV.mas_centerY);
    }];
    
    UIButton *detaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [detaBgView addSubview:detaBtn];
    detaBtn.userInteractionEnabled = NO;
    [detaBtn setTitle:@"查看详情 >" forState:UIControlStateNormal];
    detaBtn.titleLabel.font = Font(13);
    [detaBtn setTitleColor:[UIColor colorBlueTextColor] forState:UIControlStateNormal];
    [detaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(detaBgView).offset(-KSIphonScreenW(10));
        make.centerY.equalTo(detaBgView.mas_centerY);
    }];
}
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    // 姓名
    self.nameView.subTitleLab.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
    // 性别
    self.sexView.subTitleLab.text = [NSString stringWithFormat:@"%@",dict[@"sex"]];
    // 作业类型
    self.jobCategoryView.subTitleLab.text = [NSString stringWithFormat:@"%@",dict[@"certificate_name"]];
    // 操作项目
    self.operatItemView.subTitleLab.text = [NSString stringWithFormat:@"%@",dict[@"project"]];
    
    // 状态 1-正常;2-异常 ,
    NSString *statuStr = [NSString stringWithFormat:@"%@",dict[@"status"]];
    if ([statuStr isEqualToString:@"2"]) {
        self.showErrorLab.text = [NSString stringWithFormat:@"%@",dict[@"message"]];
        self.showErrorLab.hidden = NO;
        self.errorImageV.hidden = NO;
    }else{
        self.errorImageV.hidden = YES;
        self.showErrorLab.text = @"";
        self.showErrorLab.hidden = YES;
    }
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
