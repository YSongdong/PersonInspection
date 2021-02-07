//
//  YWTQueryProgressView.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/12.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTQueryProgressView : UIView
// 采集人脸背景view
@property (nonatomic,strong) UIView *faceBgView;
// 采集人脸背景imageV
@property (nonatomic,strong) UIImageView *faceBgImageV;
@property (nonatomic,strong) UILabel *faceLab;
// 核实证件背景view
@property (nonatomic,strong) UIView *idBgView;
// 核实证件背景imageV
@property (nonatomic,strong) UIImageView *idBgImageV;
@property (nonatomic,strong) UILabel *idLab;
// 进度背景view
@property (nonatomic,strong) UIView *progressBgView;


// 是不是快速查询  yes 是 默认 NO  不是
@property (nonatomic,assign) BOOL isQuickSearch;

// 通过人脸，验证证件
-(void) passFaceVerifiId;

@end

NS_ASSUME_NONNULL_END
