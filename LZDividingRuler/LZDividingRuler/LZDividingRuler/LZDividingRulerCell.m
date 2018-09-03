//
//  LZDividingRulerCell.m
//  LZDividingRuler
//
//  Created by liuzhixiong on 2018/9/3.
//  Copyright © 2018年 liuzhixiong. All rights reserved.
//

#import "LZDividingRulerCell.h"
#import "Masonry.h"

@interface LZDividingRulerCell ()

@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UILabel*titleLabel;

@property (nonatomic,strong)UIColor   * scaleTextColor;
@property (nonatomic,strong)UIFont    * scaleTextFont;
@property (nonatomic,assign)CGFloat     textLargeLineSpace;
@property (nonatomic,copy)  NSString  * showText;
@property (nonatomic,strong)UIView    * inPointView;

@end

@implementation LZDividingRulerCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.lineView = [[UIView alloc]init];
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.width.equalTo(@40);
        make.height.equalTo(@20);
        make.centerX.equalTo(self.contentView);
    }];
    
    self.inPointView = [[UIView alloc]init];
    [self.contentView addSubview:self.inPointView];
    [self.inPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lineView.mas_top).offset(-10);
        make.width.height.equalTo(@6);
        make.centerX.equalTo(self.lineView.mas_centerX);
    }];
}

-(void)setModel:(LZDividingRulerModel *)model{
    [self.lineView setBackgroundColor:model.isLargeLine?model.largeLineColor:model.smallLineColor];
    CGFloat lineWidth  = model.isLargeLine?model.lineWidth:model.lineWidth;
    CGFloat lineHeight = model.isLargeLine?model.largeLineHeight:model.smallLineHeight;
    CGFloat bottomOffset = model.isLargeLine?5:(model.largeLineHeight-model.smallLineHeight)/2+5;
    bottomOffset = model.currentRulerAlignment == LZRulerTypeAlignmentCenter?bottomOffset:5;
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-bottomOffset);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.equalTo(@(lineWidth));
        make.height.equalTo(@(lineHeight));
    }];
}


-(void)updateCellWithText:(NSString *)showText font:(UIFont *)font textColor:(UIColor *)textColor textLargeLineSpace:(CGFloat)space isSelected:(BOOL)isSelected{
    
    self.showText = showText;
    self.scaleTextFont = font;
    self.scaleTextColor = textColor;
    self.textLargeLineSpace = space;
    
    NSDictionary *attributes  = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize showTextSize = [showText sizeWithAttributes:attributes];
    
    if (showText || ![showText isEqualToString:@""]) {
        [self.titleLabel setHidden:NO];
        [self.titleLabel setText:showText];
    }else{
        [self.titleLabel setHidden:YES];
    }
    
    [self.titleLabel setTextColor:textColor];
    [self.titleLabel setFont:font];
    
    if (isSelected) {
        [self.titleLabel setTextColor:[UIColor whiteColor]];
    }else{
        [self.titleLabel setTextColor:self.scaleTextColor];
    }
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lineView.mas_top).offset(-space);
        make.width.equalTo(@(showTextSize.width+2));
        make.height.equalTo(@(showTextSize.height));
        make.centerX.equalTo(self.contentView);
    }];
}

-(void)updateCellinPointColor:(UIColor *)color pointWH:(CGFloat)wh largeSpace:(CGFloat)space isShow:(BOOL)isShow{
    [self.inPointView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(wh));
        make.centerX.equalTo(self.lineView.mas_centerX);
        make.bottom.equalTo(self.lineView.mas_top).offset(-space);
    }];
    
    [self.inPointView setHidden:!isShow];
    [self.inPointView setBackgroundColor:color];
    [self.inPointView.layer setCornerRadius:wh/2];
    [self.inPointView.layer setMasksToBounds:YES];
}


@end
