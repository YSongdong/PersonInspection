//
//  UIImage+YWTExpand.m
//  PersonInspection
//
//  Created by 世界之窗 on 2020/6/4.
//  Copyright © 2020 世界之窗. All rights reserved.
//

#import "UIImage+YWTExpand.h"
#import <GPUImage/GPUImage.h>

@implementation UIColor (RGB)

- (UInt32)RGBA {
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 0;
    
    BOOL succ = [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    UInt32 r = round(red*255);
    UInt32 g = round(green*255);
    UInt32 b = round(blue*255);
    UInt32 a = round(alpha*255);

    r = (r << 24);
    g = (g << 16);
    b = (b << 8);
    
    UInt32 rgba = r + g + b + a;
    return succ ? rgba : 0x00000000;
}


@end


@implementation UIImage (YWTExpand)

+(UIImage*)imageChangeName:(NSString *)nameStr{
    NSString *str ;
    if (KTargetPerson_CS) {
        str  = [NSString stringWithFormat:@"%@_cs",nameStr];
    }else{
        str = nameStr;
    }
    UIImage *image = [UIImage imageNamed:str];
    return image;
}

- (UIImage *)fixOrientation {
    
    CGAffineTransform transform = CGAffineTransformIdentity;
 
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) {
        transform = CGAffineTransformTranslate(transform, 0, self.size.width);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             self.size.height,
                                             self.size.width,
                                             CGImageGetBitsPerComponent(self.CGImage),
                                             0,
                                             CGImageGetColorSpace(self.CGImage),    //CGImageGetColorSpace(self.CGImage)
                                             CGImageGetBitmapInfo(self.CGImage) //CGImageGetBitmapInfo(self.CGImage)
                                             );
    
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

// 添加滤镜
-(UIImage *)addImageFilterImamge:(UIImage*)image{
    
    // 添加饱和度滤镜
//    UIImage *sImage = [self getAddSaturationFilterImage:image];

    //添加对比度滤镜
    UIImage *cImage = [self getAddContrastFilterImage:image];
    
    // 颜色贴换
    UIImage *img = [cImage translatePixelColorByTargetTransColor:[UIColor colorTextWhiteColor]];
    
    return img;
}
// 添加饱和度滤镜
-(UIImage*) getAddSharpenFilterImage:(UIImage*)img{
    //  创建滤镜
    GPUImageSharpenFilter *disFilter = [[GPUImageSharpenFilter alloc] init];
    disFilter.sharpness =4;
      
    //设置要渲染的区域
    [disFilter forceProcessingAtSize:img.size];
    [disFilter useNextFrameForImageCapture];
      
    //获取数据源
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc]initWithImage:img];
    //添加上滤镜
    [stillImageSource addTarget:disFilter];

    //开始渲染
    [stillImageSource processImage];
    //获取渲染后的图片
    UIImage *image = [disFilter imageFromCurrentFramebuffer];
    return image;
}


// 添加饱和度滤镜
-(UIImage*) getAddSaturationFilterImage:(UIImage*)img{
    //  创建滤镜
    GPUImageSaturationFilter *disFilter = [[GPUImageSaturationFilter alloc] init];
    disFilter.saturation =2;
      
    //设置要渲染的区域
    [disFilter forceProcessingAtSize:img.size];
    [disFilter useNextFrameForImageCapture];
      
    //获取数据源
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc]initWithImage:img];
    //添加上滤镜
    [stillImageSource addTarget:disFilter];

    //开始渲染
    [stillImageSource processImage];
    //获取渲染后的图片
    UIImage *image = [disFilter imageFromCurrentFramebuffer];
    return image;
}
// 添加对比度滤镜
-(UIImage*) getAddContrastFilterImage:(UIImage*)img{
    //  创建滤镜
    GPUImageContrastFilter *disFilter = [[GPUImageContrastFilter alloc] init];
    disFilter.contrast =4;
      
    //设置要渲染的区域
    [disFilter forceProcessingAtSize:img.size];
    [disFilter useNextFrameForImageCapture];
      
    //获取数据源
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc]initWithImage:img];
    //添加上滤镜
    [stillImageSource addTarget:disFilter];

    //开始渲染
    [stillImageSource processImage];
    //获取渲染后的图片
    UIImage *image = [disFilter imageFromCurrentFramebuffer];
    return image;
}

void providerReleaseDataCallback (void *info, const void *data, size_t size) {
    free((void*)data);
}
- (UIImage *)translatePixelColorByTargetTransColor:(UIColor *)transColor{
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UInt32 transRGBA = transColor.RGBA;
    return [self translatePixelColorByTransColorRGBA:transRGBA inRect:rect];
}
- (UIImage *)translatePixelColorByTransColorRGBA:(UInt32)transRGBA inRect:(CGRect)rect {
    CGRect canvas = CGRectMake(0, 0, self.size.width, self.size.height);
    if (!CGRectContainsRect(canvas, rect)) {
        if (CGRectIntersectsRect(canvas, rect)) {
            rect = CGRectIntersection(canvas, rect);    // 取交集
        } else {
            return self;
        }
    }
    
    UIImage *transImage = nil;
    
    int imageWidth = self.size.width;
    int imageHeight = self.size.height;
    
    size_t bytesPerRow = imageWidth * 4;
    uint32_t *rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    
    
    // 遍历并修改像素
    uint32_t *pCurPtr = rgbImageBuf;
    pCurPtr += (long)(rect.origin.y*imageWidth);    // 将指针移动到初始行的起始位置
    
    // 空间复杂度：O(rect.size.width * rect.size.height)
    for (int i = rect.origin.y; i < CGRectGetMaxY(rect); i++) {                     // row
        pCurPtr += (long)rect.origin.x;             // 将指针移动到当前行的起始列
        for (int j = rect.origin.x; j < CGRectGetMaxX(rect); j++, pCurPtr++) {      // column
            uint8_t *ptr = (uint8_t *)pCurPtr;
            if ((ptr[2]-ptr[1] > 30) && (ptr[2]-ptr[3] > 30)) {
                ptr[3] = (transRGBA >> 24) & 0xFF;             // R
                ptr[2] = (transRGBA >> 16) & 0xFF;            // G
                ptr[1] = (transRGBA >> 8)  & 0xFF;           // B
            }
            // 将图片转成想要的颜色
//            uint8_t *ptr = (uint8_t *)pCurPtr;
//            ptr[3] = (transRGBA >> 24) & 0xFF;              // R
//            ptr[2] = (transRGBA >> 16) & 0xFF;              // G
//            ptr[1] = (transRGBA >> 8)  & 0xFF;              // B
        }
        
        pCurPtr += (long)(imageWidth - CGRectGetMaxX(rect));    // 将指针移动到下一行的起始列
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, providerReleaseDataCallback);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    transImage = [UIImage imageWithCGImage:imageRef];
    
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return transImage ? : self;
}



@end
