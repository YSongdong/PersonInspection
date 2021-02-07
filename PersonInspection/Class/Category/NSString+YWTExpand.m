//
//  NSString+YWTExpand.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/6/30.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "NSString+YWTExpand.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (YWTExpand)
//提取字符串中的所有数字
+(NSString*) getStringNumber:(NSString*)string{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    string = [[string componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
    return string;
}
// 去掉空格
+(NSString*) getCharacSetString:(NSString*)string{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／:：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
    NSString *str = [string stringByTrimmingCharactersInSet:set];
    return str;
}
// 根据规则pattern  替换成空
+(NSString*) getStringPattern:(NSString*)pattern allStr:(NSString*)string{
    // 替换字母
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSString *zStr = [regularExpression stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:@""];
    zStr = [NSString getCharacSetString:zStr];
    return zStr;
}
// 提取中文
+(NSArray*) getStringChinaStr:(NSString*)string{
    NSMutableArray *arr = [NSMutableArray array];
    if (string == nil || [string isEqual:@""]) {return arr.copy;}
    for (int i=0; i<string.length; i++) {
        int a = [string characterAtIndex:i];
        if (a < 0x9fff && a > 0x4e00) {
            [arr addObject:[string substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    return arr.copy;
}
// 根据中文 替换成空
+(NSString*) getStringChinaReplaceArr:(NSArray*)arr andStr:(NSString*)string{
    for (int i=0; i< arr.count; i++) {
        NSString *chinaStr = arr[i];
        string = [string stringByReplacingOccurrencesOfString:chinaStr withString:@""];
    }
    
    string = [NSString getCharacSetString:string];
    return string;
}
// 提取证件号
+(NSString *) getIdentNumberStr:(NSString*)string{
    // 根据规则pattern  替换成空
    string =  [NSString getStringPattern:@"[a-z^A-Z]" allStr:string];
    // 去掉空格
    string = [NSString getCharacSetString:string];
    // 提取中文 替换成空
    NSString *key = [NSString getAStringOfChineseWord:string];
    return key;
}
// 提取中文 替换成空
+(NSString *)getAStringOfChineseWord:(NSString *)string{
    NSMutableArray *arr = [NSMutableArray array];
    if (string == nil || [string isEqual:@""]) {return string;}
    for (int i=0; i<string.length; i++) {
        int a = [string characterAtIndex:i];
        if (a < 0x9fff && a > 0x4e00) {
            [arr addObject:[string substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    for (int i=0; i< arr.count; i++) {
        NSString *chinaStr = arr[i];
        string = [string stringByReplacingOccurrencesOfString:chinaStr withString:@""];
    }
    return string;
}

//AES128位加密 base64编码 注：kCCKeySizeAES128点进去可以更换256位加密
+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key{
    char keyPtr[kCCKeySizeAES128+1];//
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
        NSString *stringBase64 = [resultData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]; // base64格式的字符串
        return stringBase64;
        
    }
    free(buffer);
    return nil;
}
//解密
+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:encryptText options:NSDataBase64DecodingIgnoreUnknownCharacters];//base64解码
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    return nil;
}

// 判断字符串是否在百家姓内
+(BOOL) jumpBookOfFamilyName:(NSString*)nameStr{
    BOOL isName = NO;
    
    if (nameStr.length < 2) {
        return isName;
    }
    
    NSArray *arr = [NSString bookOfFamilyName];
    // 单姓
    NSString *keyStr  = [nameStr substringToIndex:1];
    NSString *keyStr1  = [nameStr substringToIndex:2];
    for (int i=0; i<arr.count; i++) {
        NSString *str = arr[i];
        if ([keyStr isEqualToString:str]) {
            if (nameStr.length > 2) {
                return YES;
            }
        }
    }
    for (int i=0; i<arr.count; i++) {
        NSString *str = arr[i];
        if ([keyStr1 isEqualToString:str]) {
            if (nameStr.length > 4) {
                 return YES;
            }
        }
    }
    return isName;
}
// 百家姓
+(NSArray*) bookOfFamilyName{
    NSArray *arr = @[@"赵", @"钱", @"孙", @"李", @"周", @"吴", @"郑", @"王", @"冯", @"陈",
                    @"褚", @"卫", @"蒋", @"沈", @"韩", @"杨", @"朱", @"秦", @"尤", @"许",
                    @"何", @"吕", @"施", @"张", @"孔", @"曹", @"严", @"华", @"金", @"魏",
                    @"陶", @"姜", @"戚", @"谢", @"邹", @"喻", @"柏", @"水", @"窦", @"章",
                    @"云", @"苏", @"潘", @"葛", @"奚", @"范", @"彭", @"郎", @"鲁", @"韦",
                    @"昌", @"马", @"苗", @"凤", @"花", @"方", @"俞", @"任", @"袁", @"柳",
                    @"酆", @"鲍", @"史", @"贺", @"唐", @"费", @"廉", @"岑", @"薛", @"雷",
                    @"倪", @"汤", @"滕", @"殷", @"罗", @"毕", @"郝", @"邬", @"安", @"常",
                    @"乐", @"于", @"时", @"傅", @"皮", @"卞", @"齐", @"康", @"伍", @"余",
                    @"元", @"卜", @"顾", @"孟", @"平", @"黄", @"和", @"穆", @"萧", @"尹",
                    @"姚", @"邵", @"湛", @"汪", @"祁", @"毛", @"禹", @"狄", @"米", @"贝",
                    @"明", @"臧", @"计", @"伏", @"成", @"戴", @"谈", @"宋", @"茅", @"庞",
                    @"熊", @"纪", @"舒", @"屈", @"项", @"祝", @"董", @"粱", @"杜", @"阮",
                    @"蓝", @"闵", @"席", @"季", @"麻", @"强", @"贾", @"路", @"娄", @"危",
                    @"江", @"童", @"颜", @"郭", @"梅", @"盛", @"林", @"刁", @"钟", @"徐",
                    @"邱", @"骆", @"高", @"夏", @"蔡", @"田", @"樊", @"胡", @"凌", @"霍",
                    @"虞", @"万", @"支", @"柯", @"昝", @"管", @"卢", @"莫", @"经", @"房",
                    @"裘", @"缪", @"干", @"解", @"应", @"宗", @"丁", @"宣", @"贲", @"邓",
                    @"郁", @"单", @"杭", @"洪", @"包", @"诸", @"左", @"石", @"崔", @"吉",
                    @"钮", @"龚", @"程", @"嵇", @"邢", @"滑", @"裴", @"陆", @"荣", @"翁",
                    @"荀", @"羊", @"於", @"惠", @"甄", @"麴", @"家", @"封", @"芮", @"羿",
                    @"储", @"靳", @"汲", @"邴", @"糜", @"松", @"井", @"段", @"富", @"巫",
                    @"乌", @"焦", @"巴", @"弓", @"牧", @"隗", @"山", @"谷", @"车", @"侯",
                    @"宓", @"蓬", @"全", @"郗", @"班", @"仰", @"秋", @"仲", @"伊", @"宫",
                    @"宁", @"仇", @"栾", @"暴", @"甘", @"钭", @"厉", @"戎", @"祖", @"武",
                    @"符", @"刘", @"景", @"詹", @"束", @"龙", @"叶", @"幸", @"司", @"韶",
                    @"郜", @"黎", @"蓟", @"薄", @"印", @"宿", @"白", @"怀", @"蒲", @"邰",
                    @"从", @"鄂", @"索", @"咸", @"籍", @"赖", @"卓", @"蔺", @"屠", @"蒙",
                    @"池", @"乔", @"阴", @"欎", @"胥", @"能", @"苍", @"双", @"闻", @"莘",
                    @"党", @"翟", @"谭", @"贡", @"劳", @"逄", @"姬", @"申", @"扶", @"堵",
                    @"冉", @"宰", @"郦", @"雍", @"舄", @"璩", @"桑", @"桂", @"濮", @"牛",
                    @"寿", @"通", @"边", @"扈", @"燕", @"冀", @"郏", @"浦", @"尚", @"农",
                    @"温", @"别", @"庄", @"晏", @"柴", @"瞿", @"阎", @"充", @"慕", @"连",
                    @"茹", @"习", @"宦", @"艾", @"鱼", @"容", @"向", @"古", @"易", @"慎",
                    @"戈", @"廖", @"庾", @"终", @"暨", @"居", @"衡", @"步", @"都", @"耿",
                    @"满", @"弘", @"匡", @"国", @"文", @"寇", @"广", @"禄", @"阙", @"东",
                    @"殴", @"殳", @"沃", @"利", @"蔚", @"越", @"夔", @"隆", @"师", @"巩",
                    @"厍", @"聂", @"晁", @"勾", @"敖", @"融", @"冷", @"訾", @"辛", @"阚",
                    @"那", @"简", @"饶", @"空", @"曾", @"毋", @"沙", @"乜", @"养", @"鞠",
                    @"须", @"丰", @"巢", @"关", @"蒯", @"相", @"查", @"後", @"荆", @"红",
                    @"游", @"竺", @"权", @"逯", @"盖", @"益", @"桓", @"公", @"墨", @"哈",
                    @"谯", @"笪", @"年", @"爱", @"阳", @"佟", @"商", @"帅", @"佘", @"佴",
                    @"仉", @"督", @"归", @"海", @"伯", @"赏", @"岳", @"楚", @"缑", @"亢",
                    @"况", @"后", @"有", @"琴", @"言", @"福", @"晋", @"牟", @"闫", @"法",
                    @"汝", @"鄢", @"涂", @"钦",@"蹇", @"东郭", @"南门", @"呼延", @"羊舌", @"微生", @"左丘",
                    @"万俟", @"司马", @"上官", @"欧阳", @"夏侯", @"诸葛", @"闻人", @"东方", @"赫连", @"皇甫",
                    @"尉迟", @"公羊", @"澹台", @"公冶", @"宗政", @"濮阳", @"东门", @"西门", @"南宫", @"第五",
                    @"淳于", @"单于", @"太叔", @"申屠", @"公孙", @"仲孙", @"轩辕", @"令狐", @"钟离", @"宇文",
                    @"长孙", @"慕容", @"鲜于", @"闾丘", @"司徒", @"司空", @"亓官", @"司寇", @"子车", @"夹谷",
                    @"颛孙", @"端木", @"巫马", @"公西", @"漆雕", @"乐正", @"壤驷", @"公良", @"拓跋", @"梁丘",
                    @"宰父", @"谷梁", @"段干", @"百里"];
    return arr;
}






@end
