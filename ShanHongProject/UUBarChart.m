//
//  UUBarChart.m
//  UUChartDemo
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUBarChart.h"
#import "UUChartLabel.h"
#import "UUBar.h"

@interface UUBarChart ()
{
    UIScrollView *myScrollView;
}
@end

@implementation UUBarChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(UUYLabelwidth, 0, frame.size.width-UUYLabelwidth, frame.size.height)];
        [self addSubview:myScrollView];
    }
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    NSInteger min = 1000000000;
    for (NSArray * ary in yLabels) {
        for (NSString *valueString in ary) {
            NSInteger value = [valueString integerValue];
            if (value > max) {
                max = value;
            }
            if (value < min) {
                min = value;
            }
        }
    }
    if (max < 6) {
        max = 6;
    }
    if (self.showRange) {
        _yValueMin = (int)min;
    }else{
        _yValueMin = 0;
    }
    _yValueMax = (int)max;
    
    if (_chooseRange.max!=_chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }

    float level = (_yValueMax-fabs(_yValueMin)) /4.0; //7.75
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3; //230
    CGFloat levelHeight = chartCavanHeight /4.0; //57.5px
    
    for (int i=0; i<5; i++) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight-i*levelHeight, UUYLabelwidth, UULabelHeight)];
		label.text = [NSString stringWithFormat:@"%.1f",level * i+_yValueMin];
		[self addSubview:label];
    }
    
    //画横线
    for (int i=0; i<5; i++) {
        if ([_ShowHorizonLine[i] integerValue]>0) {
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(UUYLabelwidth,UULabelHeight+i*levelHeight)];
            [path addLineToPoint:CGPointMake(self.frame.size.width,UULabelHeight+i*levelHeight)];
            [path closePath];
            shapeLayer.path = path.CGPath;
            if (i != 0) {
                shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.8] CGColor];
                shapeLayer.fillColor = [[UIColor blackColor] CGColor];
                shapeLayer.lineWidth = 1;
            }else{
                shapeLayer.strokeColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.1] CGColor];
                shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
                shapeLayer.lineWidth = 1;
            }
            
            [self.layer addSublayer:shapeLayer];
        }
    }

	
}

-(void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
    NSInteger num;
    if (xLabels.count>=8) {
        num = 8;
    }else if (xLabels.count<=4){
        num = 4;
    }else{
        num = xLabels.count;
    }
    _xLabelWidth = myScrollView.frame.size.width/num;//64.5
    
    for (int i=0; i<xLabels.count; i++) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake((i *  _xLabelWidth ), self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight)];
        label.text = xLabels[i];
        [myScrollView addSubview:label];
    }
    
    float max = (([xLabels count]-1)*_xLabelWidth + chartMargin)+_xLabelWidth;
    if (myScrollView.frame.size.width < max-10) {
        myScrollView.contentSize = CGSizeMake(max, self.frame.size.height+ 10);
    }else{
        myScrollView.contentSize = CGSizeMake(max, self.frame.size.height+ 10);
    }
    
    //画竖线
    for (int i=0; i<xLabels.count; i++) {
        if ([_ShowVericationLine[i] integerValue] > 0) {
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(UUYLabelwidth+i*_xLabelWidth,UULabelHeight)];
           // [path addLineToPoint:CGPointMake(UUYLabelwidth+i*_xLabelWidth,self.frame.size.height-UULabelHeight)];
             [path addLineToPoint:CGPointMake(UUYLabelwidth+i*_xLabelWidth,self.frame.size.height-UULabelHeight * 2)];
            [path closePath];
            shapeLayer.path = path.CGPath;
            shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.8] CGColor];
            shapeLayer.fillColor = [[UIColor blackColor] CGColor];
            shapeLayer.lineWidth = 1;
            [self.layer addSublayer:shapeLayer];
        }
    }

}
-(void)setColors:(NSArray *)colors
{
	_colors = colors;
}
- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

- (void)setShowHorizonLine:(NSMutableArray *)ShowHorizonLine
{
    _ShowHorizonLine = ShowHorizonLine;
}

- (void)setShowVericationLine:(NSMutableArray *)ShowVericationLine
{
    _ShowVericationLine = ShowVericationLine;
}
-(void)strokeChart
{
    
    CGFloat chartCavanHeight = self.frame.size.height - 3*UULabelHeight;
	
    for (int i=0; i<_yValues.count; i++) {
        if (i==2)
            return;
        NSArray *childAry = _yValues[i];
        for (int j=0; j<childAry.count; j++) {
            NSString *valueString = childAry[j];
            float value = [valueString floatValue];
            float grade = ((float)fabs(value)-_yValueMin) / ((float)_yValueMax-fabs(_yValueMin));
            
            UUBar * bar = [[UUBar alloc] initWithFrame:CGRectMake((j+(_yValues.count==1?0.1:0.05))*_xLabelWidth +i*_xLabelWidth * 0.47, UULabelHeight, _xLabelWidth * (_yValues.count==1?0.8:0.45), chartCavanHeight)];
            bar.barColor = [_colors objectAtIndex:i];
            bar.grade = grade;
            [myScrollView addSubview:bar];
            
            float y = myScrollView.frame.size.height - (UULabelHeight*4+(bar.frame.size.height * grade));
            UUChartLabel *valueLabel = [[UUChartLabel alloc] initWithFrame:CGRectMake(bar.frame.origin.x, y, bar.frame.size.width, UULabelHeight)];
            if ([valueString floatValue] != 0.0) {
                valueLabel.text = valueString;
            }
            if ([valueString floatValue] < 0) {
                valueLabel.textColor = [UIColor redColor];
            }
            [myScrollView addSubview:valueLabel];

        }
    }
    
   // [myScrollView setContentOffset:CGPointMake(0, -10)];
}

@end
