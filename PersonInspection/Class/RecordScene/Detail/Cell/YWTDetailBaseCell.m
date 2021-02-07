//
//  YWTDetailBaseCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/18.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTDetailBaseCell.h"
#import "YWTRecordBaseView.h"

@interface YWTDetailBaseCell ()
// 证件号码
@property (nonatomic,strong) YWTRecordBaseView *idNumberView;
// 姓名
@property (nonatomic,strong) YWTRecordBaseView *nameView;
// 异常问题
@property (nonatomic,strong) YWTRecordBaseView *abNormalView;
// 当前位置
@property (nonatomic,strong) YWTRecordBaseView *addressView;
// 相关项目
@property (nonatomic,strong) YWTRecordBaseView *projectView;
@end

@implementation YWTDetailBaseCell

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
    bgView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorViewShallowerDarkBlackColor] normalCorlor:[UIColor colorTextWhiteColor]];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(KSIphonScreenH(3));
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(12));
        make.bottom.equalTo(weakSelf).offset(-KSIphonScreenH(12));
    }];
    bgView.layer.shadowColor = [UIColor colorWithHexString:@"#000000"].CGColor;
    bgView.layer.shadowRadius = 3;
    bgView.layer.shadowOffset = CGSizeMake(0, 0);
    bgView.layer.shadowOpacity = 0.10;
    bgView.layer.cornerRadius = 10/2;
    
    self.idNumberView = [[YWTRecordBaseView alloc]init];
    [bgView addSubview:self.idNumberView];
    [self.idNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(bgView);
        make.height.equalTo(@(KSIphonScreenH(45)));
    }];
    self.idNumberView.baseTitleLab.text = @"证件号码";
    self.idNumberView.baseSubTiltlLab.textColor = [UIColor colorNamlCommonTextColor];
    self.idNumberView.baseTitleLab.font = Font(14);
    self.idNumberView.baseSubTiltlLab.font = Font(14);
    
    self.nameView = [[YWTRecordBaseView alloc]init];
    [bgView addSubview:self.nameView];
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.idNumberView.mas_bottom);
        make.left.equalTo(weakSelf.idNumberView.mas_left);
        make.width.height.equalTo(weakSelf.idNumberView);
        make.centerX.equalTo(weakSelf.idNumberView.mas_centerX);
    }];
    self.nameView.baseTitleLab.text = @"姓名";
    self.nameView.baseSubTiltlLab.textColor = [UIColor colorNamlCommonTextColor];
    self.nameView.baseTitleLab.font = Font(14);
    self.nameView.baseSubTiltlLab.font = Font(14);
    
    self.abNormalView = [[YWTRecordBaseView alloc]init];
    [bgView addSubview:self.abNormalView];
    [self.abNormalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameView.mas_bottom);
        make.left.equalTo(weakSelf.idNumberView.mas_left);
        make.width.height.equalTo(weakSelf.idNumberView);
        make.centerX.equalTo(weakSelf.idNumberView.mas_centerX);
    }];
    self.abNormalView.baseTitleLab.text = @"异常问题";
    self.abNormalView.baseSubTiltlLab.textColor = [UIColor colorNamlCommonTextColor];
    self.abNormalView.baseTitleLab.font = Font(14);
    self.abNormalView.baseSubTiltlLab.font = Font(14);

    self.addressView = [[YWTRecordBaseView alloc]init];
    [bgView addSubview:self.addressView];
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.abNormalView.mas_bottom);
        make.left.equalTo(weakSelf.idNumberView.mas_left);
        make.width.height.equalTo(weakSelf.idNumberView);
        make.centerX.equalTo(weakSelf.idNumberView.mas_centerX);
    }];
    self.addressView.baseTitleLab.text = @"当前位置";
    self.addressView.baseSubTiltlLab.textColor = [UIColor colorNamlCommonTextColor];
    self.addressView.baseSubTiltlLab.text = @"";
    self.addressView.baseTitleLab.font = Font(14);
    self.addressView.baseSubTiltlLab.font = Font(14);

    self.projectView = [[YWTRecordBaseView alloc]init];
    [bgView addSubview:self.projectView];
    [self.projectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.addressView.mas_bottom);
        make.left.equalTo(weakSelf.idNumberView.mas_left);
        make.width.height.equalTo(weakSelf.idNumberView);
        make.centerX.equalTo(weakSelf.idNumberView.mas_centerX);
    }];
    self.projectView.lineView.hidden = YES;
    self.projectView.baseSubTiltlLab.textColor = [UIColor colorNamlCommonTextColor];
    self.projectView.baseTitleLab.text = @"相关项目";
    self.projectView.baseTitleLab.font = Font(14);
    self.projectView.baseSubTiltlLab.font = Font(14);
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    // 证件号码
    self.idNumberView.baseSubTiltlLab.text = [NSString stringWithFormat:@"%@",dict[@"certificate_num"]];
    
    // 姓名
    self.nameView.baseSubTiltlLab.text =  [NSString stringWithFormat:@"%@",dict[@"name"]];
    
    // 异常问题
    self.abNormalView.baseSubTiltlLab.text = [NSString stringWithFormat:@"%@",dict[@"problem"]];
    
    // 当前位置
    self.addressView.baseSubTiltlLab.text = [NSString stringWithFormat:@"%@",dict[@"location"]];
    
    // 相关项目
    self.projectView.baseSubTiltlLab.text =  [NSString stringWithFormat:@"%@",dict[@"project"]];
    
    
}




@end
