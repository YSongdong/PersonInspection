//
//  YWTLocationModel.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/18.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YWTLocationModel : NSObject
/// POI名称
@property (nonatomic, copy) NSString *name;
/// POI坐标
@property (nonatomic, assign) CLLocationCoordinate2D pt;
/// POI地址信息
@property (nonatomic, copy) NSString *address;
/// POI电话号码
@property (nonatomic, copy) NSString *phone;
/// POI唯一标识符uid
@property (nonatomic, copy) NSString *UID;
/// POI所在省份
@property (nonatomic, copy) NSString *province;
/// POI所在城市
@property (nonatomic, copy) NSString *city;
/// POI所在行政区域
@property (nonatomic, copy) NSString *area;

@end

NS_ASSUME_NONNULL_END
