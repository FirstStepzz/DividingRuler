
# DividingRuler
自定义滑动刻度尺，滑动标尺，实现简单，所有参数可完全自定义

帮到的话，别忘了给个✨星星啊，兄弟们～

![image](https://upload-images.jianshu.io/upload_images/2572565-3f1f118418af1de0.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/261/format/webp)

使用方法：
 -(void)setupTwoRuler{
    
    // 变速区域
    LZDividingRulerView * rulerView = [[LZDividingRulerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 51)];
    //使用刻度尺常规模式
    rulerView.isCustomScalesValue = NO;
    //不显示刻度尺上的文案
    rulerView.isShowScaleText = NO;
    //显示刻度尺中当前值文案
    rulerView.isShowCurrentValue = YES;
    //最大值
    rulerView.maxValue = 1000000;
    //最小值
    rulerView.minValue = 100;
    //单元值
    rulerView.unitValue = 100;
    //默认值
    rulerView.defaultValue = 10100;
    //两个刻度文案之间的刻度格数
    rulerView.scalesCountBetweenScaleText = 5;
    
    //结束滚动
    [rulerView setDividingRulerDidEndScrollingBlock:^NSString *(CGFloat value) {
        return [NSString stringWithFormat:@"%.f",value];
    }];
    //滚动中
    [rulerView setDividingRulerDidScrollBlock:^NSString *(CGFloat value,CGPoint rulerContentOffset) {
        return [NSString stringWithFormat:@"%.f",value];
    }];
    [rulerView setFrame:CGRectMake(0, 160, CGRectGetWidth(self.view.frame), 52)];
    [rulerView updateRuler];
    [self.view addSubview:rulerView];
}

其他可见简书：https://www.jianshu.com/p/2523c4f22ce8



