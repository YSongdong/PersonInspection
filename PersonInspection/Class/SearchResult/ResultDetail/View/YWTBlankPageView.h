//
//  YWTBlankPageView.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/15.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YWTBlankPageViewDelegate <NSObject>

-(void) pushPageRecordBtn;

-(void) pushPageBackBtn;


@end

@interface YWTBlankPageView : UIView
@property (nonatomic,weak) id<YWTBlankPageViewDelegate>delegate;

@property (nonatomic,strong) UIImageView *imageV;

@property (nonatomic,strong) UILabel *showTitleLab;

@property (nonatomic,strong) UILabel *showSubTitleLab;


@property (nonatomic,strong) UIButton *recordBtn;

@property (nonatomic,strong) UIButton *homeBtn;
@end

NS_ASSUME_NONNULL_END
