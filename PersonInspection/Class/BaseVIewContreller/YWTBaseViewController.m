//
//  YWTBaseViewController.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/9.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTBaseViewController.h"

@interface YWTBaseViewController ()<
UIGestureRecognizerDelegate
>
@end

@implementation YWTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNavBar];
}
- (void)setupNavBar{
    [self.view addSubview:self.customNavBar];

    // 设置自定义导航栏背景图片
    self.customNavBar.barBackgroundColor = [UIColor colorViewBackGrounpWhiteColor];
 
    // 设置自定义导航栏标题颜色
    self.customNavBar.titleLabelColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorTextWhiteColor] normalCorlor:[UIColor colorWithHexString:@"#000000"]];

    // 设置线条颜色
    self.customNavBar.bottomLine.backgroundColor = [UIColor colorLineCommonTextColor];
}
- (WRCustomNavigationBar *)customNavBar{
    if (_customNavBar == nil) {
        _customNavBar = [WRCustomNavigationBar CustomNavigationBar];
    }
    return _customNavBar;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.childViewControllers.count == 1) {
        return NO;
    }else{
        return YES;
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}




@end
