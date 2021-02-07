//
//  YWTHomeMarkCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/9.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTHomeMarkCell.h"

@implementation YWTHomeMarkCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}
-(void) createCell{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#0a70cf"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(23));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.equalTo(@2);
        make.height.equalTo(@20);
    }];
    
    UILabel *lab = [[UILabel alloc]init];
    [self addSubview:lab];
    lab.text = @"请选择";
    lab.textColor = [UIColor colorNamlCommonTextColor];
    lab.font =  BFont(19);
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(KSIphonScreenW(6));
        make.centerY.equalTo(lineView.mas_centerY);
    }];
    
    UILabel *markLab = [[UILabel alloc]init];
    [self addSubview:markLab];
    markLab.text = @"两种查询方式，您可任选其一";
    markLab.textColor = [UIColor colorNamlCommon98TextColor];
    markLab.font = Font(12);
    [markLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(23));
        make.centerY.equalTo(lab.mas_centerY);
    }];
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
