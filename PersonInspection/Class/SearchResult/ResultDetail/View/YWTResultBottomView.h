//
//  YWTResultBottomView.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/14.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YWTResultBottomViewDelegate <NSObject>

-(void) pushRecordBtn;

-(void) pushBackBtn;

@end


@interface YWTResultBottomView : UIView

@property (nonatomic,weak) id<YWTResultBottomViewDelegate>delegate;

@property (nonatomic,strong) UIButton *recordBtn;

@property (nonatomic,strong) UIButton *homeBtn;

// 判断不是正确   yes 是 NO 不是， 默认NO
@property (nonatomic,assign) BOOL   isSuccess;

@end

NS_ASSUME_NONNULL_END
