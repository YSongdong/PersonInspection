//
//  YWTCurrentLocationController.h
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/16.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YWTCurrentLocationControllerDelegate <NSObject>

-(void) selectLocationData:(NSString*)locationStr;

@end

@interface YWTCurrentLocationController : YWTBaseViewController

@property (nonatomic,weak) id <YWTCurrentLocationControllerDelegate> delegate;

@property (nonatomic,strong) BMKLocation *mLoction;

@end


