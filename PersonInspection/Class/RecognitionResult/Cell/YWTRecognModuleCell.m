//
//  YWTRecognModuleCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/19.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTRecognModuleCell.h"

@implementation YWTRecognModuleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    WS(weakSelf);
    self.backgroundColor = [UIColor clearColor];
    
    UIView *bgView = [[UIView alloc]init];
    [self.contentView addSubview:bgView];
    bgView.backgroundColor = [UIColor clearColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(weakSelf);
    }];
    
    self.lineView = [[UIView alloc]init];
    [bgView addSubview:self.lineView];
    self.lineView.backgroundColor = [UIColor colorLineCommonTextColor];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(KSIphonScreenW(12));
        make.right.equalTo(bgView).offset(-KSIphonScreenW(12));
        make.bottom.equalTo(bgView);
        make.height.equalTo(@1);
    }];
    
    self.baseTitleLab = [[UILabel alloc]init];
    [bgView addSubview:self.baseTitleLab];
    self.baseTitleLab.text = @"";
    self.baseTitleLab.textColor = [UIColor colorNamlCommonTextColor];
    self.baseTitleLab.font = Font(16);
    self.baseTitleLab.textAlignment = NSTextAlignmentJustified;
    [self.baseTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(KSIphonScreenW(12));
        make.centerY.equalTo(bgView.mas_centerY);
        make.width.equalTo(@66);
    }];
    
    self.itmeTextF = [[UITextField alloc]init];
    [bgView addSubview:self.itmeTextF];
    self.itmeTextF.textColor = [UIColor colorNamlCommonTextColor];
    self.itmeTextF.font = Font(15);
    self.itmeTextF.placeholder = @"";
    self.itmeTextF.textAlignment = NSTextAlignmentRight;
    self.itmeTextF.delegate = self;
    [self.itmeTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.lineView.mas_right);
        make.top.bottom.equalTo(bgView);
        make.left.equalTo(weakSelf.baseTitleLab.mas_right).offset(KSIphonScreenW(30));
    }];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillHide:(NSNotification*)tifi{
    [self.itmeTextF resignFirstResponder];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -----  UITextFieldDelegate ----
// 点击完成按钮
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
// 开始编辑
- (void)textFieldDidBeginEditing:(UITextField*)textField{
    //显示
}
// 结束编辑
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.finishText(textField.text);
//    //隐藏
//    [textField resignFirstResponder];
}
// 适配深色模式
-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    if (@available(iOS 13.0, *)) {
        if (previousTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            // 不是深色模式
            self.backgroundColor = [UIColor  colorTextWhiteColor];
        }else{
            // 深色模式
            self.backgroundColor = [UIColor colorWithHexString:@"#1e2838"];
        }
    } else {
        self.backgroundColor = [UIColor colorTextWhiteColor];
    }
}
-(void)setFrame:(CGRect)frame{
    frame.origin.x = KSIphonScreenW(12);
    frame.size.width -=KSIphonScreenW(24);
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
