//
//  YWTInquiryRecordCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/7/2.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTInquiryRecordCell.h"

@interface YWTInquiryRecordCell ()


@property (nonatomic,strong) UILabel *idnetNemberLab;

@property (nonatomic,strong) UILabel *nameLab;

@end

@implementation YWTInquiryRecordCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}
-(void) createCell{
    self.backgroundColor = [UIColor colorViewF2F2BackGrounpWhiteColor];
    
    WS(weakSelf);
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorViewShallowDarkBlackColor] normalCorlor:[UIColor colorWithHexString:@"#e8e8e8"]];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(KSIphonScreenH(3));
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(12));
        make.bottom.equalTo(weakSelf).offset(-KSIphonScreenH(3));
    }];
    bgView.layer.cornerRadius = 2;
    bgView.layer.masksToBounds = YES;
    
    
    self.idnetNemberLab = [[UILabel alloc]init];
    [bgView addSubview:self.idnetNemberLab];
    self.idnetNemberLab.textColor = [UIColor colorWithHexString:@"#909090"];
    self.idnetNemberLab.font = Font(13);
    [self.idnetNemberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(KSIphonScreenW(10));
        make.centerY.equalTo(bgView.mas_centerY);
    }];
    
    self.nameLab = [[UILabel alloc]init];
    [bgView addSubview:self.nameLab];
    self.nameLab.textColor = [UIColor colorWithHexString:@"#909090"];
    self.nameLab.font = Font(13);
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-KSIphonScreenW(10));
        make.centerY.equalTo(bgView.mas_centerY);
    }];
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    // 证件号
    self.idnetNemberLab.text = [NSString stringWithFormat:@"%@",dict[@"certificate_num"]];
    
    // 姓名
    self.nameLab.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
    
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
