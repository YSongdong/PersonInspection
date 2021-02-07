//
//  YWTBusinessCertificateModel.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/26.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWTCertificateModel : NSObject <YYModel>
// 人脸
@property (nonatomic,copy) UIImage *faceImage;
// 证件
@property (nonatomic,copy) UIImage *certificateImage;
//是否扫描证件状态：1-打开类型选择页面；2-不打开类型选择页面直接请求websocket接口；3-跳转列表页面
@property (nonatomic,copy) NSString *status;
// 是否扫描证件状态：0-查无此证;1-正常；2-异常;
@property (nonatomic,copy) NSString *result_status;
// 姓名 ,
@property (nonatomic,copy) NSString *name;
//身份证号
@property (nonatomic,copy) NSString *id_card;
//头像 ,
@property (nonatomic,copy) NSString *face_url;
//人员id ,
@property (nonatomic,copy) NSString *constructor_id;
//证件图片 ,
@property (nonatomic,copy) NSString *certificate_url;
// 证件号 ,
@property (nonatomic,copy) NSString *certificate_num;
// 证件类型名称 ,,
@property (nonatomic,copy) NSString *certificate_name;
// 证件类型
@property (nonatomic,copy) NSString *certificate_type;
// 记录id ,
@property (nonatomic,copy) NSString *record_id;

@property (nonatomic,copy) NSString *errorMsg;

@end











