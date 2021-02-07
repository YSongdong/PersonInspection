//
//  YWTHomeHistoryRecordCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/11.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTHomeHistoryRecordCell.h"

@implementation YWTHomeHistoryRecordCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}
-(void) createCell{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    
    UIImageView *bgImageV = [[UIImageView alloc]init];
    [self addSubview:bgImageV];
    bgImageV.image = [UIImage imageNamed:@"sy_pic_bg"];
    [bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    
    UIView *recordView = [[UIView alloc]init];
    [self addSubview:recordView];
    
    UIImageView *recordImageV = [[UIImageView alloc]init];
    [recordView addSubview:recordImageV];
    recordImageV.image = [UIImage imageNamed:@"sy_ico_04"];
    recordImageV.contentMode = UIViewContentModeScaleAspectFit;
    [recordImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(recordView);
    }];
    
    UILabel *recordLab = [[UILabel alloc]init];
    [recordView addSubview:recordLab];
    recordLab.textColor = [UIColor colorNamlCommon65TextColor];
    recordLab.font = Font(14);
    [recordLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(recordImageV.mas_right).offset(KSIphonScreenW(7));
        make.centerY.equalTo(recordImageV.mas_centerY);
    }];
    // 下划线
     NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
     NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"历史查询记录" attributes:attribtDic];
    recordLab.attributedText = attribtStr;
    
    [recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(recordLab.mas_top);
        make.left.equalTo(recordImageV.mas_left);
        make.right.bottom.equalTo(recordLab);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.centerX.equalTo(weakSelf.mas_centerX);
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
