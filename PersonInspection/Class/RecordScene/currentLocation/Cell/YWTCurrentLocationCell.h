//
//  YWTCurrentLocationCell.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/16.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <BaiduMapAPI_Search/BMKPoiSearchType.h>
NS_ASSUME_NONNULL_BEGIN

@interface YWTCurrentLocationCell : UITableViewCell

@property (nonatomic,strong) UIButton *selectBtn;

@property (nonatomic,strong) BMKPoiInfo *poiInfo;

@end

NS_ASSUME_NONNULL_END
