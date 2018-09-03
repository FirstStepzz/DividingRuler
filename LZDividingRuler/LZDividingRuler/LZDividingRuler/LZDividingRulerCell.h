//
//  LZDividingRulerCell.h
//  LZDividingRuler
//
//  Created by liuzhixiong on 2018/9/3.
//  Copyright © 2018年 liuzhixiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZDividingRulerModel.h"

@interface LZDividingRulerCell : UICollectionViewCell

@property (nonatomic,strong)          LZDividingRulerModel *model;

-(void)updateCellWithText:(NSString *)showText font:(UIFont *)font textColor:(UIColor *)textColor textLargeLineSpace:(CGFloat)space isSelected:(BOOL)isSelected;
-(void)updateCellinPointColor:(UIColor *)color pointWH:(CGFloat)wh largeSpace:(CGFloat)space isShow:(BOOL)isShow;


@end
