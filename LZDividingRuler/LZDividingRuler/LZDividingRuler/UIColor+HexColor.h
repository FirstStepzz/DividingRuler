//
//  UIColor+HexColor.h
//  LZDividingRuler
//
//  Created by liuzhixiong on 2018/9/3.
//  Copyright © 2018年 liuzhixiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
