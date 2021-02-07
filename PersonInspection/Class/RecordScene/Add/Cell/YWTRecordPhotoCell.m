//
//  YWTRecordPhotoCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/15.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTRecordPhotoCell.h"

@interface YWTRecordPhotoCell ()

@property (nonatomic,strong) UIImageView *photoImageV;

@property (nonatomic,strong) UIButton *delegateBtn;

@end
@implementation YWTRecordPhotoCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createCell];
    }
    return self;
}
-(void) createCell{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    
    self.photoImageV = [[UIImageView alloc]init];
    [self addSubview:self.photoImageV];
    self.photoImageV.image = [UIImage imageNamed:@"result_btn_add"];
    self.photoImageV.contentMode = UIViewContentModeScaleAspectFill;
    self.photoImageV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.photoImageV.clipsToBounds = YES;
    [self.photoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    self.delegateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.delegateBtn];
    [self.delegateBtn setImage:[UIImage imageNamed:@"jlxc_pic_delete"] forState:UIControlStateNormal];
    [self.delegateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(weakSelf);
        make.width.height.equalTo(@30);
    }];
    [self.delegateBtn addTarget:self action:@selector(selectDelBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setModel:(YWTAddRecordModel *)model{
    _model = model;
    self.delegateBtn.enabled = YES;
    self.photoImageV.image = model.photoImage;
    
    self.delegateBtn.hidden =  !model.isDel;
    
}

-(void)setShowModel:(YWTAddRecordModel *)showModel{
    _showModel = showModel;
    
    self.delegateBtn.hidden =  !showModel.isDel;
    
    [YWTTools sd_setImageView:self.photoImageV WithURL:showModel.photoUrlStr andPlaceholder:@"cxjl_pic_jzsb"];

}
-(void)setIsHiddenDelBtn:(BOOL)isHiddenDelBtn{
    _isHiddenDelBtn = isHiddenDelBtn;
    if (isHiddenDelBtn) {
        self.delegateBtn.hidden = isHiddenDelBtn;
    }
}
-(void)selectDelBtn:(UIButton*)sender{
    if (self.delegateBtn.enabled) {
        self.selectCellDel();
        self.delegateBtn.enabled = NO;
    }
}



@end
