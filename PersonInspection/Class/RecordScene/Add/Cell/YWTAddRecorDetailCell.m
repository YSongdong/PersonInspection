//
//  YWTAddRecorDetailCell.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/5/16.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "YWTAddRecorDetailCell.h"

@implementation YWTAddRecorDetailCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self =  [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    WS(weakSelf);
    self.backgroundColor = [UIColor colorViewBackGrounpWhiteColor];
    
    self.fsTextView = [[FSTextView alloc]init];
    [self addSubview:self.fsTextView];
    self.fsTextView.placeholder = @"请在这里输入详细描述...";
    self.fsTextView.placeholderFont = Font(14);
    self.fsTextView.placeholderColor = [UIColor colorNamlCommon98TextColor];
    self.fsTextView.borderWidth = 1;
    self.fsTextView.borderColor = [UIColor colorLineCommonTextColor];
    self.fsTextView.font = Font(14);
    self.fsTextView.textColor = [UIColor colorNamlCommonTextColor];
    self.fsTextView.returnKeyType = UIReturnKeyDone;
    self.fsTextView.delegate = self;
    self.fsTextView.textContainerInset = UIEdgeInsetsMake(3, 3, 3, 3);
    [self.fsTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(KSIphonScreenH(24));
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.bottom.equalTo(weakSelf).offset(-KSIphonScreenH(24));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(12));
    }];
    self.fsTextView.layer.cornerRadius = 10/2;
    self.fsTextView.layer.masksToBounds = YES;
    self.fsTextView.backgroundColor = [UIColor colorStyleLeDarkWithConstantColor:[UIColor colorWithHexString:@"#263143"] normalCorlor:[UIColor colorWithHexString:@"#f5f5f5"]];
}

-(void)setModel:(YWTAddRecordModel *)model{
    _model = model;

    self.fsTextView.text = model.subTitleStr;
    
}
// 适配深色模式
-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    if (@available(iOS 13.0, *)) {
        if (previousTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            // 不是深色模式
           self.fsTextView.borderColor = [UIColor colorWithHexString:@"#e6e6e6"];
        }else{
            // 深色模式
            self.fsTextView.borderColor = [UIColor colorWithHexString:@"#404856"];
        }
    } else {
        self.fsTextView.borderColor = [UIColor colorWithHexString:@"#e6e6e6"];
    }
}
#pragma mark --- UITextViewDelegate -----
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        [self endEditing:YES];
        
        self.model.subTitleStr = textView.text;
        self.selectDetailDone(self.model);
        return NO;
    }
    //判断键盘是不是九宫格键盘
    if ([self isNineKeyBoard:text] ){
        return YES;
    }else{
        if ([self hasEmoji:text] || [self stringContainsEmoji:text]){
           
            return NO;
        }
    }
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    self.model.subTitleStr = textView.text;
    self.selectDetailDone(self.model);
}

/**
 *  判断字符串中是否存在emoji
 * @param string 字符串
 * @return YES(含有表情)
 */
- (BOOL)stringContainsEmoji:(NSString *)string{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    return returnValue;
}
/**
 判断是不是九宫格
 @param string  输入的字符
 @return YES(是九宫格拼音键盘)
 */
-(BOOL)isNineKeyBoard:(NSString *)string
{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++)
    {
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}
/**
 *  判断字符串中是否存在emoji
 * @param string 字符串
 * @return YES(含有表情)
 */
- (BOOL)hasEmoji:(NSString*)string;
{
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

@end
