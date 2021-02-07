//
//  YWTCurrentLocationCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/16.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTCurrentLocationCell.h"

@interface YWTCurrentLocationCell ()

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UILabel *subTitleLab;

@end



@implementation YWTCurrentLocationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}
-(void)createView{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.selectBtn];
    self.selectBtn.userInteractionEnabled = NO;
    [self.selectBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageChangeName:@"dqwz_ico_xz"] forState:UIControlStateSelected];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(10));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.height.equalTo(@40);
    }];
    
    self.titleLab = [[UILabel alloc]init];
    [bgView addSubview:self.titleLab];
    self.titleLab.text = @"";
    self.titleLab.textColor = [UIColor colorNamlCommonTextColor];
    self.titleLab.font = BFont(16);
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(bgView);
    }];
    
    self.subTitleLab = [[UILabel alloc]init];
    [bgView addSubview:self.subTitleLab];
    self.subTitleLab.text = @"";
    self.subTitleLab.textColor = [UIColor colorNamlCommon98TextColor];
    self.subTitleLab.font = Font(12);
    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLab.mas_bottom).offset(KSIphonScreenH(5));
        make.left.equalTo(weakSelf.titleLab.mas_left);
        make.right.equalTo(bgView);
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLab.mas_top);
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.right.equalTo(weakSelf.selectBtn.mas_left).offset(-KSIphonScreenW(5));
        make.bottom.equalTo(weakSelf.subTitleLab.mas_bottom);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorLineCommonTextColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.height.equalTo(@1);
    }];
}
-(void)setPoiInfo:(BMKPoiInfo *)poiInfo{
    _poiInfo = poiInfo;
    
    self.titleLab.text = poiInfo.name;
    
     self.subTitleLab.text = poiInfo.address;
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
