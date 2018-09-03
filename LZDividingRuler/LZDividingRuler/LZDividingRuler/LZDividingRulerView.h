//
//  LZDividingRulerView.h
//  LZDividingRuler
//
//  Created by liuzhixiong on 2018/9/3.
//  Copyright © 2018年 liuzhixiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZDividingRulerModel.h"
#import <AudioToolbox/AudioToolbox.h>

@interface LZDividingRulerView : UIView



/** 刻度尺是否可滚动；默认YES */
@property (nonatomic,assign) BOOL                   isScrollEnable;
/** 刻度尺两侧是否需要渐变阴影；默认YES */
@property (nonatomic,assign) BOOL                   isShowBothEndsOfGradient;
/** 刻度尺中间是否需要显示当前值；默认NO */
@property (nonatomic,assign) BOOL                   isShowCurrentValue;
/** 刻度尺上侧是否显示刻度内容；默认YES */
@property (nonatomic,assign) BOOL                   isShowScaleText;
/** 刻度尺上侧是否显示归零球；默认 NO */
@property (nonatomic,assign) BOOL                   isShowInPoint;
/** 刻度尺中间是否展示浮标；默认 YES */
@property (nonatomic,assign) BOOL                   isShowIndicator;
/** 刻度尺是否需要自定义，即刻度尺每个刻度非递增；默认 NO */
@property (nonatomic,assign) BOOL                   isCustomScalesValue;
/** 刻度尺是否需要在刻度处自动吸附；默认 YES */
@property (nonatomic,assign) BOOL                   isShouldAdsorption;
/** 刻度尺浮标处刻度内容是否需要高亮；默认 YES */
@property (nonatomic,assign) BOOL                   isShouldHighlightText;
/** 刻度尺底部横线是否显示；默认 NO */
@property (nonatomic,assign) BOOL                   isShowBottomLine;

/**    刻度     */
@property (nonatomic,assign) CGFloat                lineSpace;
@property (nonatomic,assign) CGFloat                lineWidth;
@property (nonatomic,assign) CGFloat                largeLineHeight;
@property (nonatomic,strong) UIColor              * largeLineColor;
@property (nonatomic,strong) UIColor              * smallLineColor;
@property (nonatomic,assign) CGFloat                smallLineHeight;
@property (nonatomic,assign) NSInteger              scalesCountBetweenLargeLine;
@property (nonatomic,assign) NSInteger              scalesCountBetweenScaleText;
@property (nonatomic,assign) LZRulerAlignmentType currentRulerAlignment;


/**   刻度显示文本  */
@property (nonatomic,strong) UIColor              * scaleTextColor;
@property (nonatomic,strong) UIFont               * scaleTextFont;
@property (nonatomic,copy)   NSString             * (^scaleTextFormatBlock)(CGFloat currentValue,NSInteger scaleIndex);
@property (nonatomic,assign) CGFloat                scaleTextLargeLineSpace;


/**    值     */
@property (nonatomic,assign) CGFloat                maxValue;
@property (nonatomic,assign) CGFloat                minValue;
@property (nonatomic,assign) CGFloat                unitValue;
@property (nonatomic,assign) CGFloat                defaultValue;


/**    中间浮标     */
@property (nonatomic,strong) UIColor              * indicatorViewColor;
@property (nonatomic,assign) CGFloat                indicatorHeight;
@property (nonatomic,assign) CGFloat                indicatorWidth;


/**    归零点原球     */
@property (nonatomic,strong) UIColor              * inPointColor;
@property (nonatomic,assign) CGFloat                inPointWH;
@property (nonatomic,assign) CGFloat                inPointLargeLineSpace;
@property (nonatomic,assign) CGFloat                inPointCurrentValue;      //需要显示归零球的值
@property (nonatomic,assign) CGFloat                inPointCurrentScale;     //自定义刻度时，需要显示归零球的刻度

/**    两侧渐变色     */
@property (nonatomic,assign) CGFloat                gradientLayerWidth;

/**    底线     */
@property (nonatomic,strong) UIColor              * bottomLineColor;
@property (nonatomic,assign) CGFloat                bottomLineHeight;

/**    回调当前值     */
@property (nonatomic,copy)   NSString *             (^dividingRulerDidEndScrollingBlock)(CGFloat value);
@property (nonatomic,copy)   NSString *             (^dividingRulerDidScrollBlock) (CGFloat value,CGPoint rulerContentOffset);



/**    自定义刻度相关     */
@property (nonatomic,assign) NSInteger              customScalesCount;
@property (nonatomic,assign) CGFloat                defaultScale;
@property (nonatomic,copy)   NSString             * (^customScaleTextFormatBlock)(CGFloat currentCalibrationIndex);
@property (nonatomic,copy)   NSString             * (^dividingRulerCustomScaleDidEndScrollingBlock)(CGFloat index);
@property (nonatomic,copy)   NSString             * (^dividingRulerCustomScaleDidScrollBlock)(CGFloat index);


/**
 更新刻度尺数据显示，数据更新后，必须调用此方法来更新数据，否则不会生效
 */
-(void)updateRuler;

- (void)updateScrollerViewContentOffset:(CGPoint)pointOffset;



@end
