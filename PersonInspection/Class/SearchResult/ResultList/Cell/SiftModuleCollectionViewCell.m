//
//  SiftModuleCollectionViewCell.m
//  PartyBuildingStar
//
//  Created by tiao on 2019/1/15.
//  Copyright © 2019年 wutiao. All rights reserved.
//

#import "SiftModuleCollectionViewCell.h"

@interface SiftModuleCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *moduleBgView;
@property (weak, nonatomic) IBOutlet UILabel *moduleTitleLab;

@end

@implementation SiftModuleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.moduleBgView.layer.cornerRadius = 4;
    self.moduleBgView.layer.masksToBounds = YES;
    self.moduleBgView.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
}
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    self.moduleTitleLab.text = dict[@"title"];
    
    // isSelect  1 选中 2 不选中
    NSString *isSelectStr = [NSString stringWithFormat:@"%@",dict[@"isSelect"]];
    if ([isSelectStr isEqualToString:@"1"]) {
        self.moduleTitleLab.textColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorTextWhiteColor] normalCorlor:[UIColor colorBlueTextColor]];
        if (KTargetPerson_CS) {
            self.moduleBgView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorBlueTextColor] normalCorlor:[UIColor colorWithHexString:@"#f0f7f6"]];
        }else{
            self.moduleBgView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorBlueTextColor] normalCorlor:[UIColor colorWithHexString:@"#e9f0ff"]];
        }
    }else{
        if (KTargetPerson_CS) {
             self.moduleBgView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorWithHexString:@"#263143"] normalCorlor:[UIColor colorWithHexString:@"#f0f7f6"]];
        }else{
             self.moduleBgView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorWithHexString:@"#263143"] normalCorlor:[UIColor colorSiftTextColor]];
        }
        self.moduleTitleLab.textColor = [UIColor colorNamlCommonTextColor];
    }

}



@end
