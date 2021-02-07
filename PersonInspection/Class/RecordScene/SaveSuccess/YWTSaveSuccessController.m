//
//  YWTSaveSuccessController.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/25.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTSaveSuccessController.h"

#import "YWTRecordSceneDetailController.h"
#import "YWTBlankPageView.h"
#import "YWTSearchResultController.h"

@interface YWTSaveSuccessController ()
<
YWTBlankPageViewDelegate
>
@property (nonatomic,strong)YWTBlankPageView *blankPageView;
@end

@implementation YWTSaveSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    // 设置导航栏
    [self setNavi];
    [self.view addSubview:self.blankPageView];
    // 跳转到指导页面
    [self getJumpDesigViewController];
}
#pragma mark ---  YWTBlankPageViewDelegate ----
-(void) pushPageRecordBtn{
    YWTRecordSceneDetailController *recodVC = [[YWTRecordSceneDetailController alloc]init];
    recodVC.idStr = self.idStr;
    [self.navigationController pushViewController:recodVC animated:YES];
}
-(void) pushPageBackBtn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
// 指导跳转到页面
-(void) getJumpDesigViewController{
    NSArray *viewS = self.navigationController.viewControllers;
    NSMutableArray *mTmp = [NSMutableArray array];
    NSInteger index = 0;
    for (NSInteger i = viewS.count; i > 0; i--) {
        UIViewController *VC = viewS[i-1];
        if ([VC isKindOfClass:[YWTSearchResultController class]]) {
            index = i;
            break;
        }
    }
    for (NSInteger j = 0; j < index; j++) {
        [mTmp addObject:viewS[j]];
    }
    [mTmp addObject:[viewS lastObject]];
    self.navigationController.viewControllers = (NSArray*)mTmp;
}
#pragma  mark ----------------  设置导航栏--------------------
-(void) setNavi{
    [self.customNavBar wr_setBackgroundAlpha:1];
    self.customNavBar.title =@"保存成功";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_btn_back"]];
    WS(weakSelf);
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
-(YWTBlankPageView *)blankPageView{
    if (!_blankPageView) {
        _blankPageView = [[YWTBlankPageView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-KSTabbarH)];
        _blankPageView.delegate = self;
        [_blankPageView.recordBtn setTitle:@"查看记录" forState:UIControlStateNormal];
        _blankPageView.imageV.image = [UIImage imageChangeName:@"pic_jlcg"];
        _blankPageView.showTitleLab.text = @"现场记录成功!";
        _blankPageView.showSubTitleLab.text = @"您已成功记录此次现场，后台同步信息更直观!";
    }
    return _blankPageView;
}
-(void)setIdStr:(NSString *)idStr{
    _idStr = idStr;
}

@end
