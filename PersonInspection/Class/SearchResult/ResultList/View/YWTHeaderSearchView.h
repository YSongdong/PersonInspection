//
//  YWTHeaderSearchView.h
//  YWTCloudVideo
//
//  Created by 世界之窗 on 2019/11/21.
//  Copyright © 2019 世界之窗. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YWTHeaderSearchViewDelegate <NSObject>

-(void) selectSearchBtn:(NSString*)searchStr;

@end

@interface YWTHeaderSearchView : UIView

@property (nonatomic,weak) id <YWTHeaderSearchViewDelegate>delegate;

@property (nonatomic,strong) UITextField *searchTF;

@property (nonatomic,strong) UIImageView *leftImageV;



@end


