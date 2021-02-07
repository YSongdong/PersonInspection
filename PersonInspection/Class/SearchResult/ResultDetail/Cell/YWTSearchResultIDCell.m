//
//  YWTSearchResultIDCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/14.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTSearchResultIDCell.h"

#import "YWTBaseIDCellView.h"

@interface YWTSearchResultIDCell ()
@property (nonatomic,strong) UIView *bigBgView;
// 证件号码
@property (nonatomic,strong) UILabel *idNumberLab;
// 姓名
@property (nonatomic,strong) UILabel *personNameLab;
// 作业类别
@property (nonatomic,strong) UILabel *jobCategoryLab;
// 操作项目
@property (nonatomic,strong) UILabel *operatItemLab;
// 发证机关
@property (nonatomic,strong) YWTBaseIDCellView *lssuAuthorView;
//发证日期
@property (nonatomic,strong) YWTBaseIDCellView *lssueDateView;
//应复审日期
@property (nonatomic,strong) YWTBaseIDCellView *dueDateView;
//有效期开始时间
@property (nonatomic,strong) YWTBaseIDCellView *expirationDateBeginTimeView;
//有效期结束时间
@property (nonatomic,strong) YWTBaseIDCellView *expirationDateEndTimeView;
//实际复审时间
@property (nonatomic,strong) YWTBaseIDCellView *actualRviewTimeView;
// 状态
@property (nonatomic,strong) UIImageView *statuImageV;
@end


@implementation YWTSearchResultIDCell

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
    promptLab.text = @"证件信息";
    promptLab.textColor = [UIColor colorNamlCommonTextColor];
    promptLab.font = BFont(12);
    [promptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(promptLineView.mas_right).offset(KSIphonScreenW(4));
        make.centerY.equalTo(promptLineView.mas_centerY);
    }];
    
    UIView *idBgView = [[UIView alloc]init];
    [self.bigBgView addSubview:idBgView];
    [idBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptBgView.mas_bottom);
        make.left.right.bottom.equalTo(weakSelf.bigBgView);
    }];
    
    // 证件号码
    self.idNumberLab = [[UILabel alloc]init];
    [idBgView addSubview:self.idNumberLab];
    self.idNumberLab.text = @"";
    self.idNumberLab.textColor = [UIColor colorNamlCommonTextColor];
    self.idNumberLab.font = BFont(21);
    [self.idNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(idBgView).offset(KSIphonScreenH(15));
        make.left.equalTo(idBgView).offset(KSIphonScreenW(12));
    }];
    
    UIView *workBgView = [[UIView alloc]init];
    [idBgView addSubview:workBgView];
    workBgView.backgroundColor = [UIColor colorViewF2F6BackGrounpWhiteColor];
    if (KTargetPerson_CS) {
        workBgView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorWithHexString:@"#263143"] normalCorlor:[UIColor colorWithHexString:@"#f0f7f6"]];
    }else{
       workBgView.backgroundColor = [UIColor colorViewF2F6BackGrounpWhiteColor];
    }
    
    UIView *workView = [[UIView alloc]init];
    [workBgView addSubview:workView];
    
    self.personNameLab = [[UILabel alloc]init];
    [workView addSubview:self.personNameLab];
    self.personNameLab.text= @"";
    self.personNameLab.textColor = [UIColor colorNamlCommon98TextColor];
    self.personNameLab.font = Font(13);
    [self.personNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(workView);
    }];
    
    // 作业类别
    self.jobCategoryLab = [[UILabel alloc]init];
    [workView addSubview:self.jobCategoryLab];
    self.jobCategoryLab.text= @"作业类别:";
    self.jobCategoryLab.textColor = [UIColor colorNamlCommon98TextColor];
    self.jobCategoryLab.font = Font(13);
    [self.jobCategoryLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.personNameLab.mas_left);
        make.top.equalTo(weakSelf.personNameLab.mas_bottom).offset(KSIphonScreenH(8));
    }];
    
    // 操作项目
    self.operatItemLab = [[UILabel alloc]init];
    [workView addSubview:self.operatItemLab];
    self.operatItemLab.text= @"操作项目:";
    self.operatItemLab.textColor = [UIColor colorNamlCommon98TextColor];
    self.operatItemLab.font = Font(13);
    [self.operatItemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.personNameLab.mas_left);
        make.top.equalTo(weakSelf.jobCategoryLab.mas_bottom).offset(KSIphonScreenH(8));
        make.right.equalTo(workView);
    }];
    
    [workView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.personNameLab.mas_top);
        make.left.equalTo(workBgView).offset(KSIphonScreenW(12));
        make.right.equalTo(workBgView).offset(-KSIphonScreenW(12));
        make.bottom.equalTo(weakSelf.operatItemLab.mas_bottom);
        make.centerY.equalTo(workBgView.mas_centerY);
        make.centerX.equalTo(workBgView.mas_centerX);
    }];
    
    [workBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.idNumberLab.mas_bottom).offset(KSIphonScreenH(15));
        make.left.equalTo(idBgView).offset(KSIphonScreenW(12));
        make.right.equalTo(idBgView).offset(-KSIphonScreenW(12));
        make.bottom.equalTo(workView.mas_bottom).offset(KSIphonScreenH(12));
    }];
    workBgView.layer.cornerRadius =  10/2;
    workBgView.layer.masksToBounds = YES;
    

    // 发证机关
    self.lssuAuthorView = [[YWTBaseIDCellView alloc]init];
    [idBgView addSubview:self.lssuAuthorView];
    self.lssuAuthorView.baseTitleLab.text = @"发证机关";
    self.lssuAuthorView.baseSubTitleLab.text = @"--";
    [self.lssuAuthorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(workBgView.mas_bottom);
        make.left.right.equalTo(idBgView);
        make.height.equalTo(@(KSIphonScreenH(35)));
    }];
    
    //发证日期
    self.lssueDateView = [[YWTBaseIDCellView alloc]init];
    [idBgView addSubview:self.lssueDateView];
    self.lssueDateView.baseTitleLab.text = @"初次发证日期";
    self.lssueDateView.baseSubTitleLab.text = @"--";
    [self.lssueDateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lssuAuthorView.mas_bottom);
        make.left.equalTo(weakSelf.lssuAuthorView.mas_left);
        make.width.height.equalTo(weakSelf.lssuAuthorView);
        make.centerX.equalTo(weakSelf.lssuAuthorView.mas_centerX);
    }];
    
    //应复审日期
    self.dueDateView = [[YWTBaseIDCellView alloc]init];
    [idBgView addSubview:self.dueDateView];
    self.dueDateView.baseTitleLab.text = @"应复审日期";
    self.dueDateView.baseSubTitleLab.text = @"--";
    [self.dueDateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lssueDateView.mas_bottom);
        make.left.equalTo(weakSelf.lssuAuthorView.mas_left);
        make.width.height.equalTo(weakSelf.lssuAuthorView);
        make.centerX.equalTo(weakSelf.lssuAuthorView.mas_centerX);
    }];
    
    //有效期开始时间
    self.expirationDateBeginTimeView = [[YWTBaseIDCellView alloc]init];
    [idBgView addSubview:self.expirationDateBeginTimeView];
    self.expirationDateBeginTimeView.baseTitleLab.text = @"有效期开始时间";
    self.expirationDateBeginTimeView.baseSubTitleLab.text = @"--";
    [self.expirationDateBeginTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.dueDateView.mas_bottom);
        make.left.equalTo(weakSelf.lssuAuthorView.mas_left);
        make.width.height.equalTo(weakSelf.lssuAuthorView);
        make.centerX.equalTo(weakSelf.lssuAuthorView.mas_centerX);
    }];
    
    //有效期结束时间
    self.expirationDateEndTimeView = [[YWTBaseIDCellView alloc]init];
    [idBgView addSubview:self.expirationDateEndTimeView];
    self.expirationDateEndTimeView.baseTitleLab.text = @"有效期结束时间";
    self.expirationDateEndTimeView.baseSubTitleLab.text = @"--";
    [self.expirationDateEndTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.expirationDateBeginTimeView.mas_bottom);
        make.left.equalTo(weakSelf.lssuAuthorView.mas_left);
        make.width.height.equalTo(weakSelf.lssuAuthorView);
        make.centerX.equalTo(weakSelf.lssuAuthorView.mas_centerX);
    }];
    
    //实际复审时间
    self.actualRviewTimeView = [[YWTBaseIDCellView alloc]init];
    [idBgView addSubview:self.actualRviewTimeView];
    self.actualRviewTimeView.baseTitleLab.text = @"实际复审时间";
    self.actualRviewTimeView.baseSubTitleLab.text = @"--";
    self.actualRviewTimeView.lineView.hidden = YES;
    [self.actualRviewTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.expirationDateEndTimeView.mas_bottom);
        make.left.equalTo(weakSelf.lssuAuthorView.mas_left);
        make.width.height.equalTo(weakSelf.lssuAuthorView);
        make.centerX.equalTo(weakSelf.lssuAuthorView.mas_centerX);
    }];
    
    // 状态
    self.statuImageV = [[UIImageView alloc]init];
    [self.bigBgView addSubview:self.statuImageV];
    self.statuImageV.image = [UIImage imageNamed:@"cxjg_pic_yzyc"];
    self.statuImageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.statuImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bigBgView).offset(1);
        make.right.equalTo(weakSelf.bigBgView).offset(-1);
    }];

}
// 适配深色模式
-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    if (@available(iOS 13.0, *)) {
        if (previousTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            // 不是深色模式
            if (KTargetPerson_CS) {
                self.bigBgView.layer.borderColor = [UIColor colorWithHexString:@"#9dcac4"].CGColor;
            }else{
                self.bigBgView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
            }
        }else{
            // 深色模式
            self.bigBgView.layer.borderColor = [UIColor colorWithHexString:@"#404856"].CGColor;
        }
    } else {
        if (KTargetPerson_CS) {
              self.bigBgView.layer.borderColor = [UIColor colorWithHexString:@"#9dcac4"].CGColor;
        }else{
              self.bigBgView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
        }
    }
}
-(void)setDict:(NSDictionary *)dict{
    
    _dict = dict;
    // 证件号码
    self.idNumberLab.text = [NSString stringWithFormat:@"%@",dict[@"certificate_num"]];
    // 名称/性别
    self.personNameLab.text= [NSString stringWithFormat:@"%@/%@",dict[@"name"],dict[@"sex"]];
    // 作业类别
    self.jobCategoryLab.text=  [NSString stringWithFormat:@"作业类别:  %@",dict[@"certificate_name"]];
    // 操作项目
    self.operatItemLab.text=[NSString stringWithFormat:@"操作项目:  %@",dict[@"project"]];
    // 发证机关
    self.lssuAuthorView.baseSubTitleLab.text = [NSString stringWithFormat:@"%@",dict[@"provide_unit"]];
    // 初次发证日期
    self.lssueDateView.baseSubTitleLab.text = [NSString stringWithFormat:@"%@",dict[@"provide_date"]];
    // 应复审日期
    self.dueDateView.baseSubTitleLab.text = [NSString stringWithFormat:@"%@",dict[@"review_date"]];
    // 有效日期
    self.expirationDateBeginTimeView.baseSubTitleLab.text = [NSString stringWithFormat:@"%@",dict[@"valid_start_data"]];
    // 有效结束日期
    self.expirationDateEndTimeView.baseSubTitleLab.text = [NSString stringWithFormat:@"%@",dict[@"valid_end_data"]];
    // 实际复审时间
    id  realityReviewDate = dict[@"reality_review_date"];
    if ([realityReviewDate isEqual:[NSNull null]]) {
        self.actualRviewTimeView.baseSubTitleLab.text = @"-";
    }else{
         self.actualRviewTimeView.baseSubTitleLab.text = [NSString stringWithFormat:@"%@",dict[@"reality_review_date"]];
    }
    //状态:1-正常;2-异常 ,
    NSString *statuStr = [NSString stringWithFormat:@"%@",dict[@"status"]];
    if ([statuStr isEqualToString:@"1"]) {
        self.statuImageV.image = [UIImage imageChangeName:@"cxjg_pic_jgzc"];
        self.expirationDateBeginTimeView.baseSubTitleLab.textColor = [UIColor colorNamlCommon98TextColor];
        self.expirationDateEndTimeView.baseSubTitleLab.textColor = [UIColor colorNamlCommon98TextColor];
    }else{
        self.statuImageV.image = [UIImage imageNamed:@"cxjg_pic_yzyc"];
        self.expirationDateBeginTimeView.baseSubTitleLab.textColor = [UIColor colorRedTextColor];
        self.expirationDateEndTimeView.baseSubTitleLab.textColor = [UIColor colorRedTextColor];
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
