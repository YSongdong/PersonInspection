//
//  YWTRecognModuleCell.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/19.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSKRoundCornerCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface YWTRecognModuleCell : KSKRoundCornerCell <UITextFieldDelegate>
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *baseTitleLab;
@property (nonatomic,strong) UITextField *itmeTextF;

@property (nonatomic,copy) void(^finishText)(NSString *text);
@end

NS_ASSUME_NONNULL_END
