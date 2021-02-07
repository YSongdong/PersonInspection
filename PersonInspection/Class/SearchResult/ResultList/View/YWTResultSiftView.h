//
//  YWTResultSiftView.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/15.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YWTResultSiftViewDelegate <NSObject>

// 点击确定按钮
-(void) selectSubmitBtnTagIdStr:(NSString *)tagIdStr;

@end


@interface YWTResultSiftView : UIView

@property (nonatomic,weak) id<YWTResultSiftViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
