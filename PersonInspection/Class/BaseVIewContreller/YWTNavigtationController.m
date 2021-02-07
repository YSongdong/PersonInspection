//
//  YWTNavigtationController.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/6/5.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTNavigtationController.h"

@interface YWTNavigtationController ()

@end

@implementation YWTNavigtationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    UIViewController *topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
