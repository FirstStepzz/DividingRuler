//
//  ViewController.m
//  LZDividingRuler
//
//  Created by liuzhixiong on 2018/9/3.
//  Copyright © 2018年 liuzhixiong. All rights reserved.
//

#import "ViewController.h"
#import "LZDividingRulerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self setupOneRuler];
    [self setupTwoRuler];
    [self setupThreeRuler];
    [self setupFourRule];
}

-(void)setupOneRuler{
    
    // 变速区域
    LZDividingRulerView * rulerView = [[LZDividingRulerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 51)];
    rulerView.isCustomScalesValue = YES;
    rulerView.scalesCountBetweenScaleText = 5;
    rulerView.customScalesCount = 30;
    rulerView.defaultScale = 15;
    NSArray *titleArray = @[@"赤",@"橙",@"黄",@"绿",@"蓝",@"靛",@"紫"];
    [rulerView setCustomScaleTextFormatBlock:^NSString *(CGFloat currentCalibrationIndex) {
        return [NSString stringWithFormat:@"%@",titleArray[(int)currentCalibrationIndex/5]];
    }];
    
    [rulerView setDividingRulerCustomScaleDidEndScrollingBlock:^NSString *(CGFloat index) {
        return nil;
    }];
    [rulerView setDividingRulerCustomScaleDidScrollBlock:^NSString *(double index) {
        return nil;
    }];
    [rulerView setFrame:CGRectMake(0, 60, CGRectGetWidth(self.view.frame), 52)];
    [rulerView updateRuler];
    [self.view addSubview:rulerView];
}

-(void)setupTwoRuler{
    
    
    // 变速区域
    LZDividingRulerView * rulerView = [[LZDividingRulerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 51)];
    rulerView.isCustomScalesValue = NO;
    rulerView.isShowScaleText = NO;
    rulerView.isShowCurrentValue = YES;
    rulerView.maxValue = 1000000;
    rulerView.minValue = 100;
    rulerView.unitValue = 100;
    rulerView.defaultValue = 10100;
    rulerView.scalesCountBetweenScaleText = 5;
    rulerView.customScalesCount = 30;
    rulerView.defaultScale = 15;
    
    [rulerView setDividingRulerDidEndScrollingBlock:^NSString *(CGFloat value) {
        return [NSString stringWithFormat:@"%.f",value];
    }];
    [rulerView setDividingRulerDidScrollBlock:^NSString *(CGFloat value,CGPoint rulerContentOffset) {
        return [NSString stringWithFormat:@"%.f",value];
    }];
    [rulerView setFrame:CGRectMake(0, 160, CGRectGetWidth(self.view.frame), 52)];
    [rulerView updateRuler];
    [self.view addSubview:rulerView];
}

-(void)setupThreeRuler{
    
    // 变速区域
    LZDividingRulerView * rulerView = [[LZDividingRulerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 51)];
    rulerView.isCustomScalesValue = NO;
    rulerView.isShowScaleText = NO;
    rulerView.isShowCurrentValue = YES;
    rulerView.isShowBottomLine = YES;
    
    rulerView.maxValue = 1000000;
    rulerView.minValue = 100;
    rulerView.unitValue = 100;
    rulerView.defaultValue = 10100;
    rulerView.scalesCountBetweenScaleText = 5;
    rulerView.customScalesCount = 30;
    rulerView.defaultScale = 15;
    rulerView.largeLineHeight = 20;
    rulerView.largeLineColor = [UIColor lightGrayColor];
    rulerView.smallLineColor = [UIColor lightGrayColor];
    rulerView.smallLineHeight = 8;
    rulerView.currentRulerAlignment = LZRulerTypeAlignmentBottom;
    
    [rulerView setDividingRulerDidEndScrollingBlock:^NSString *(CGFloat value) {
        return [NSString stringWithFormat:@"%.f",value];
    }];
    [rulerView setDividingRulerDidScrollBlock:^NSString *(CGFloat value,CGPoint rulerContentOffset) {
        return [NSString stringWithFormat:@"%.f",value];
    }];
    [rulerView setFrame:CGRectMake(0, 260, CGRectGetWidth(self.view.frame), 52)];
    [rulerView updateRuler];
    [self.view addSubview:rulerView];
}

-(void)setupFourRule{
    // 变速区域
    LZDividingRulerView * rulerView = [[LZDividingRulerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 51)];
    rulerView.isCustomScalesValue = NO;
    rulerView.isShowScaleText = YES;
    rulerView.isShowCurrentValue = NO;
    rulerView.isShowBottomLine = YES;
    rulerView.isShowIndicator = NO;
    rulerView.isShouldAdsorption = NO;
    rulerView.isShouldHighlightText = NO;
    
    rulerView.maxValue = 1000;
    rulerView.minValue = 0;
    rulerView.unitValue = 0.1;
    rulerView.defaultValue = 0;
    rulerView.scalesCountBetweenScaleText = 5;
    rulerView.customScalesCount = 30;
    rulerView.defaultScale = 15;
    rulerView.largeLineHeight = 10;
    rulerView.smallLineHeight = 6;
    rulerView.lineSpace = 4;
    rulerView.lineWidth = 0.5;
    rulerView.scalesCountBetweenScaleText = 10;
    rulerView.scaleTextLargeLineSpace = 3;
    rulerView.largeLineColor = [UIColor lightGrayColor];
    rulerView.smallLineColor = [UIColor lightGrayColor];
    rulerView.currentRulerAlignment = LZRulerTypeAlignmentBottom;
    
    [rulerView setScaleTextFormatBlock:^NSString *(CGFloat currentValue, NSInteger scaleIndex) {
        return [NSString stringWithFormat:@"%.1f",currentValue];
    }];
    
    [rulerView setDividingRulerDidEndScrollingBlock:^NSString *(CGFloat value) {
        return nil;
    }];
    [rulerView setDividingRulerDidScrollBlock:^NSString *(CGFloat value,CGPoint rulerContentOffset) {
        return nil;
    }];
    [rulerView setFrame:CGRectMake(0, 360, CGRectGetWidth(self.view.frame), 52)];
    [rulerView updateRuler];
    [self.view addSubview:rulerView];
}

@end
