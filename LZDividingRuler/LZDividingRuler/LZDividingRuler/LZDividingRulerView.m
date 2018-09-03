//
//  LZDividingRulerView.m
//  LZDividingRuler
//
//  Created by liuzhixiong on 2018/9/3.
//  Copyright © 2018年 liuzhixiong. All rights reserved.
//

#import "LZDividingRulerView.h"
#import "LZDividingRulerCell.h"
#import "UIColor+HexColor.h"
#import "Masonry.h"

@interface LZDividingRulerView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) UIView           *indicatorView;         //中间浮标
@property(nonatomic,strong) UIView           *bottomLineView;
@property(nonatomic,strong) CAGradientLayer  *leftGradientLayer;     //左阴影
@property(nonatomic,strong) CAGradientLayer  *rightGradientLayer;    //右阴影
@property(nonatomic,strong) NSMutableArray   *dataArray;             //刻度数据源
@property(nonatomic,strong) UILabel          *currentValueLabel;     //中间数值显示
@property(nonatomic,assign) CGFloat          selectedIndex;          //默认值位置
@property(nonatomic,assign) CGFloat          inPointIndex;           //归零球位置
@property(nonatomic,assign) CGFloat          totalScale;             //所有的刻度

@end

#define kMaxValue        1000000123.123
#define kMaxScalesCount  10000001230
@implementation LZDividingRulerView


-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setConfigurations];
    }
    return self;
}

-(void)setConfigurations{
    
    _isScrollEnable = YES;
    _isShowBothEndsOfGradient = YES;
    _isShowCurrentValue = NO;
    _isShowScaleText = YES;
    _isShowInPoint = NO;
    _isCustomScalesValue = NO;
    _isShouldAdsorption = YES;
    _isShouldHighlightText = YES;
    _isShowIndicator = YES;
    _isShowBottomLine = NO;
    
    /**    刻度     */
    _lineSpace = 10;
    _lineWidth = 1;
    _largeLineHeight = 11;
    _largeLineColor = [UIColor whiteColor];
    _smallLineColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.4];
    _smallLineHeight = 7;
    _scalesCountBetweenLargeLine = 5;
    _scalesCountBetweenScaleText = 5;
    _currentRulerAlignment = LZRulerTypeAlignmentCenter;
    
    /**   刻度显示文本  */
    _scaleTextColor= [UIColor colorWithHexString:@"#FFFFFF"alpha:0.4];
    _scaleTextFont = [UIFont systemFontOfSize:13];
    _scaleTextLargeLineSpace = 15;
    
    /**    值     */
    _maxValue = kMaxValue;
    _minValue = 0;
    _unitValue = 1;
    _defaultValue = 50;
    
    /**    中间浮标     */
    _indicatorHeight = 30;
    _indicatorWidth = 1;
    _indicatorViewColor = [UIColor colorWithHexString:@"#0087FF" alpha:1];
    
    /**    底部横线     */
    _bottomLineColor = [UIColor whiteColor];
    _bottomLineHeight = 0.5;
    
    /**    两侧渐变色     */
    _gradientLayerWidth = 22.5;
    
    /**    自定义刻度相关     */
    _customScalesCount = kMaxScalesCount;
    _defaultScale = 0;
    
    /**    归零点原球     */
    _inPointWH = 3;
    _inPointColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.4];
    _inPointLargeLineSpace = 6.5;
    _inPointCurrentValue = 0;
    _inPointCurrentScale = 0;
}

-(void)updateRuler{
    
    [self setupCollectionView];
    [self setupIndicatorView];
    [self setupCurrentValueLabel];
    [self setupBottomLineView];
    [self setupBothEndsOfGradientLayer];
    [self setupDataSource];
    
    [self setNeedsLayout];
}

-(void)setupCollectionView{
    [self.collectionView setContentInset:UIEdgeInsetsMake(0, CGRectGetWidth(self.frame)/2-self.lineWidth/2, 0, CGRectGetWidth(self.frame)/2-self.lineWidth/2)];
    [self.collectionView setBounces:NO];
}

-(void)setupIndicatorView{
    [self.indicatorView setBackgroundColor:self.indicatorViewColor];
    [self.indicatorView setHidden:!self.isShowIndicator];
}

-(void)setupCurrentValueLabel{
    [self.currentValueLabel setTextAlignment:NSTextAlignmentCenter];
}

-(void)setupBottomLineView{
    [self.bottomLineView setBackgroundColor:self.bottomLineColor];
    [self.bottomLineView setHidden:!self.isShowBottomLine];
}

-(void)setupBothEndsOfGradientLayer{
    [self.leftGradientLayer setHidden:!self.isShowBothEndsOfGradient];
    [self.rightGradientLayer setHidden:!self.isShowBothEndsOfGradient];
}

-(void)setupDataSource{
    if ((self.maxValue <= self.minValue || self.unitValue == 0) && !self.isCustomScalesValue) {
        NSAssert(NO, @"参数错误或者maxValue不能大于等于minuValue,each不能为0");
    }
    if (self.isShowInPoint && self.isCustomScalesValue && ((self.inPointCurrentScale >self.customScalesCount)||(self.inPointCurrentScale<0))) {
        NSAssert(NO, @"参数错误 inPointCurrentScale 不能大于最大刻度值 不能小于0");
    }
    if (self.isShowInPoint && !self.isCustomScalesValue && ((self.inPointCurrentValue >self.maxValue)||(self.inPointCurrentValue<self.minValue))) {
        NSAssert(NO, @"参数错误 inPointCurrentValue 不能大于最大值 不能小于最小值");
    }
    if (self.isCustomScalesValue && ((self.defaultScale <0)||(self.defaultScale>self.customScalesCount))) {
        NSAssert(NO, @"参数错误 defaultScale 不能大于最大刻度值 不能小于0");
    }
    if (!self.scalesCountBetweenScaleText && self.isShowScaleText) {
        NSAssert(NO, @"参数错误 scalesCountBetweenScaleText不能为0");
    }
    if (self.isCustomScalesValue && self.customScalesCount == kMaxScalesCount) {
        NSAssert(NO, @"参数错误 刻度尺数值非递增 请设置设置 customScalesCount 来确定刻度数");
    }
    if (!self.isCustomScalesValue && self.maxValue == kMaxValue) {
        NSAssert(NO, @"参数错误 刻度尺数值递增 请设置maxValue，minValue，unitValue 来确定刻度数");
    }
    
    //生成刻度循环模型
    [self.dataArray removeAllObjects];
    for (int i = 0; i<self.scalesCountBetweenLargeLine; i++) {
        LZDividingRulerModel *model = [[LZDividingRulerModel alloc]init];
        model.lineWidth = self.lineWidth;
        model.largeLineHeight = self.largeLineHeight;
        model.smallLineHeight = self.smallLineHeight;
        model.largeLineColor = self.largeLineColor;
        model.smallLineColor = self.smallLineColor;
        model.currentRulerAlignment = self.currentRulerAlignment;
        model.isLargeLine = i==0;
        [self.dataArray addObject:model];
    }
    
    //设置默认值位置
    CGFloat defaultOffset;
    if (self.isCustomScalesValue) {
        self.selectedIndex = self.defaultScale;
    }else{
        self.selectedIndex = (self.defaultValue-self.minValue)/self.unitValue;
    }
    if (self.isCustomScalesValue) {
        defaultOffset = self.selectedIndex * (self.lineWidth + self.lineSpace)-self.collectionView.contentInset.left;
    }else{
        defaultOffset = self.selectedIndex * (self.lineWidth + self.lineSpace)-self.collectionView.contentInset.left ;
    }
    
    //计算所有刻度数
    if (self.isCustomScalesValue) {
        self.totalScale = self.customScalesCount;
    }else{
        self.totalScale = (self.maxValue-self.minValue)/self.unitValue;
    }
    
    //设置计算圆球位置
    if (self.isCustomScalesValue && self.isShowInPoint) {
        self.inPointIndex = self.defaultScale;
    }else if (!self.isCustomScalesValue && self.isShowInPoint){
        self.inPointIndex = (self.inPointCurrentValue - self.minValue)/self.unitValue;
    }
    
    [self.currentValueLabel setHidden:!self.isShowCurrentValue];
    
    //刷新collectionView
    [self.collectionView setContentOffset:CGPointMake(defaultOffset, 0) animated:NO];
    [self.collectionView setScrollEnabled:self.isScrollEnable];
    [self.currentValueLabel setTextColor:self.isScrollEnable?[UIColor whiteColor]:[UIColor colorWithHexString:@"#FFFFFF" alpha:0.4]];
    [self.collectionView reloadData];
    
    if (self.isCustomScalesValue) {
        //此处是因为，设置contentOffset的是double类型，设置完后必然会走scrollDidScroll，然后又要走其中根据偏移量来计算index的方法。但是读取scrollView的contentOffset居然不保留小数位或者只保留一位小数位，精度大变，导致数据误差极大。故在此调用原偏移量进行重置。
        if (self.dividingRulerCustomScaleDidScrollBlock) {
            self.dividingRulerCustomScaleDidScrollBlock(self.defaultScale);
        }
        if (self.dividingRulerCustomScaleDidEndScrollingBlock) {
            self.dividingRulerCustomScaleDidEndScrollingBlock(self.defaultScale);
        }
    }
}

-(void)layoutSubviews{
    
    //collectionView位置
    [self.collectionView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    
    //中间标View位置
    CGFloat bottomOffset = (self.largeLineHeight - self.indicatorHeight)/2+5;
    if (self.currentRulerAlignment == LZRulerTypeAlignmentCenter) {
        [self.indicatorView setFrame:CGRectMake((CGRectGetWidth(self.frame)-self.indicatorWidth)/2, CGRectGetHeight(self.frame)-self.indicatorHeight-bottomOffset, self.indicatorWidth, self.indicatorHeight)];
    }else{
        [self.indicatorView setFrame:CGRectMake((CGRectGetWidth(self.frame)-self.indicatorWidth)/2, CGRectGetHeight(self.frame)-self.indicatorHeight-5, self.indicatorWidth, self.indicatorHeight)];
    }

    
    //中间显示数值Label位置
    [self.currentValueLabel setFrame:CGRectMake((CGRectGetWidth(self.frame)-80)/2, CGRectGetHeight(self.frame)-self.indicatorHeight-bottomOffset-6-15, 80, 15)];
    
    //底部横线
    [self.bottomLineView setFrame:CGRectMake(0, CGRectGetHeight(self.collectionView.bounds)-self.bottomLineHeight-5, self.totalScale * (self.lineSpace + self.lineWidth), self.bottomLineHeight)];
    
    //左右侧渐变阴影位置
    [self.leftGradientLayer setFrame:CGRectMake(0, 0, self.gradientLayerWidth, CGRectGetHeight(self.frame))];
    [self.rightGradientLayer setFrame:CGRectMake(CGRectGetWidth(self.frame)-self.gradientLayerWidth, 0, self.gradientLayerWidth, CGRectGetHeight(self.frame))];
}

#pragma marklargeLineColor; - CollectionViewDataSource && CollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count;
    if (self.isCustomScalesValue) {
        count = self.customScalesCount;
    }else{
        count = fabs((self.maxValue-self.minValue)/self.unitValue);
    }
    return count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LZDividingRulerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LZDividingRulerCell" forIndexPath:indexPath];
    LZDividingRulerModel *model = self.dataArray[indexPath.item % self.scalesCountBetweenLargeLine];
    cell.model = model;
    
    NSString *text;
    if (self.isCustomScalesValue) {
        if (indexPath.item % self.scalesCountBetweenScaleText == 0) {
            if (self.customScaleTextFormatBlock) {
                text = self.customScaleTextFormatBlock(indexPath.item);
            }else{
                text = nil;
            }
        }else{
            text = nil;
        }
    }else{
        if (indexPath.item % self.scalesCountBetweenScaleText == 0) {
            if (self.scaleTextFormatBlock) {
                text = self.scaleTextFormatBlock(self.minValue+self.unitValue*indexPath.item,indexPath.item);
            }else{
                text = nil;
            }
        }else{
            text = nil;
        }
    }
    if (!self.isShowScaleText) {
        text = nil;
    }
    
    //更新cell中显示文本
    BOOL isCurrentTextHighlight = indexPath.item == self.selectedIndex?YES:NO;
    isCurrentTextHighlight = self.isShouldHighlightText?isCurrentTextHighlight:NO;
    [cell updateCellWithText:text font:self.scaleTextFont textColor:self.scaleTextColor textLargeLineSpace:self.scaleTextLargeLineSpace isSelected:isCurrentTextHighlight];
    
    //更新cell中显示归零球
    BOOL isShowInPoint = self.inPointIndex == indexPath.item;
    isShowInPoint = self.selectedIndex == self.inPointIndex?NO:isShowInPoint;
    isShowInPoint = self.isShowInPoint?isShowInPoint:NO;
    [cell updateCellinPointColor:self.inPointColor pointWH:self.inPointWH largeSpace:self.inPointLargeLineSpace isShow:isShowInPoint];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.lineWidth,CGRectGetHeight(self.bounds));
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return self.lineSpace;
}

#pragma mark - ScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updateRulerLocation];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self updateRulerLocation];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat maxOffset,minOffset;
    if (self.isCustomScalesValue) {
        maxOffset = self.customScalesCount * (self.lineWidth + self.lineSpace)-self.collectionView.contentInset.left;
    }else{
        maxOffset = (self.maxValue-self.minValue)/self.unitValue*(self.lineSpace+self.lineWidth)-self.collectionView.contentInset.left;
    }
    minOffset = -self.collectionView.contentInset.left;
    
    if (scrollView.contentOffset.x >= maxOffset || scrollView.contentOffset.x <= minOffset) {
        return;
    }
    
    CGFloat offset = self.collectionView.contentInset.left + self.collectionView.contentOffset.x;
    
    CGFloat count;
    if (self.isShouldAdsorption) {
        count = (NSInteger)(offset/(self.lineWidth+self.lineSpace)+0.5);
    }else{
        count = offset/(self.lineWidth+self.lineSpace);
    }
    
    if (self.isCustomScalesValue) {
        if (self.dividingRulerCustomScaleDidScrollBlock) {
            self.currentValueLabel.text = self.dividingRulerCustomScaleDidScrollBlock(count);
        }
    }else{
        if (self.dividingRulerDidScrollBlock) {
            self.currentValueLabel.text = self.dividingRulerDidScrollBlock(self.minValue + count*self.unitValue,scrollView.contentOffset);
        }
    }
}


#pragma mark - private
-(void)updateRulerLocation{
    
    CGFloat offset = self.collectionView.contentInset.left + self.collectionView.contentOffset.x;
    
    CGFloat count;
    if (self.isShouldAdsorption) {
        count = (NSInteger)(offset/(self.lineWidth+self.lineSpace)+0.5);
    }else{
        count = offset/(self.lineWidth+self.lineSpace);
    }
    
    self.selectedIndex = count;
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake(count * (self.lineWidth+self.lineSpace)-self.collectionView.contentInset.left, 0) animated:YES];
    
    if (self.isCustomScalesValue) {
        if (self.dividingRulerCustomScaleDidScrollBlock) {
            self.currentValueLabel.text = self.dividingRulerCustomScaleDidScrollBlock(count);
        }
    }else{
        if (self.dividingRulerDidEndScrollingBlock) {
            self.currentValueLabel.text = self.dividingRulerDidEndScrollingBlock(self.minValue + count*self.unitValue);
        }
    }
    
    if (self.isShouldAdsorption) {
        //震动反馈
        AudioServicesPlaySystemSound(1519);
    }
}


/**
 同步显示位置
 
 @param pointOffset CGPoint
 */
- (void)updateScrollerViewContentOffset:(CGPoint)pointOffset{
    [self.collectionView setContentOffset:pointOffset];
}


#pragma mark - Private
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_collectionView];
        [_collectionView setBackgroundColor:[UIColor blackColor]];
        [_collectionView registerClass:[LZDividingRulerCell class] forCellWithReuseIdentifier:@"LZDividingRulerCell"];
    }
    return _collectionView;
}

-(UIView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc]init];
        [self addSubview:_indicatorView];
    }
    return _indicatorView;
}

-(UILabel *)currentValueLabel{
    if (!_currentValueLabel) {
        _currentValueLabel = [[UILabel alloc]init];
        [_currentValueLabel setTextAlignment:NSTextAlignmentCenter];
        [_currentValueLabel setFont:[UIFont systemFontOfSize:13]];
        [_currentValueLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_currentValueLabel];
    }
    return _currentValueLabel;
}

-(UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]init];
        [self.collectionView addSubview:_bottomLineView];
    }
    return _bottomLineView;
}

-(CAGradientLayer *)leftGradientLayer{
    if (!_leftGradientLayer) {
        
        _leftGradientLayer = [CAGradientLayer layer];
        _leftGradientLayer.startPoint = CGPointMake(0, 0);
        _leftGradientLayer.endPoint = CGPointMake(1, 0);
        _leftGradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#1D1D1F" alpha:0.9].CGColor,(__bridge id)[UIColor colorWithHexString:@"#1D1D1F" alpha:0].CGColor];
        [self.layer addSublayer:_leftGradientLayer];
    }
    return _leftGradientLayer;
}

-(CAGradientLayer *)rightGradientLayer{
    if (!_rightGradientLayer) {
        
        _rightGradientLayer = [CAGradientLayer layer];
        _rightGradientLayer.startPoint = CGPointMake(1, 0);
        _rightGradientLayer.endPoint = CGPointMake(0, 0);
        _rightGradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#1D1D1F" alpha:0.9].CGColor,(__bridge id)[UIColor colorWithHexString:@"#1D1D1F" alpha:0].CGColor];
        [self.layer addSublayer:_rightGradientLayer];
    }
    return _rightGradientLayer;
}

@end
