//
//  YWTAddRecordModel.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/16.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTAddRecordModel : NSObject
// 是否加载相机   yes 是 NO
@property (nonatomic,assign) BOOL isCamera;
// 图片
@property (nonatomic,copy) UIImage *photoImage;
// 图片地址
@property (nonatomic,copy) NSString *photoUrlStr;
// 是否可以删除   yes 可以删除  默认 NO
@property (nonatomic,assign) BOOL  isDel;
// 标题
@property (nonatomic,copy) NSString *titleStr;
// 副标题
@property (nonatomic,copy) NSString *subTitleStr;

@end

NS_ASSUME_NONNULL_END
