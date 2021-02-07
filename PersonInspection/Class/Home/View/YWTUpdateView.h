//
//  SDUpdateView.h
//  AgkSafetyControl
//
//  Created by tiao on 2019/1/12.
//  Copyright © 2019年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    updateTypeNonmalStatu = 0 , // 不强制更新
    updateTypeForceStatu , // 强制更新
}updateTypeStatu;

@interface YWTUpdateView : UIView

@property (nonatomic,strong) UILabel *contentLab;

// title
@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,assign) updateTypeStatu  typeStatu;

@end

NS_ASSUME_NONNULL_END
