//
//  YWTResultPromptView.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/20.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTResultPromptView : UIView

@property (nonatomic,strong) UIView *statuBgView;

@property (nonatomic,strong) UIImageView *statuImageV;

@property (nonatomic,strong) UILabel *statuPromptLab;

@property (nonatomic,strong) NSDictionary *dict;

@end

NS_ASSUME_NONNULL_END
