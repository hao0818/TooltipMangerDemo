//
//  CHPopTipViewMarkView.m
//  Fill
//
//  Created by 陈浩 on 17/2/14.
//  Copyright © 2017年 beelieve. All rights reserved.
//

#import "CHPopTipViewMarkView.h"
#import "CHPopTipView.h"
#import "TooltipManager.h"

@interface CHPopTipViewMarkView ()<CHPopTipViewDelegate>

@property (nonatomic, strong) UIColor *markColor;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGPoint targetCenter;
@property (nonatomic, strong) Tooltip *tooltip;
@property (nonatomic, weak) UIViewController *activity;

@property (nonatomic, strong) UIView *targetView;
@property(nonatomic, strong) CHPopTipView *popTipView;

@end

@implementation CHPopTipViewMarkView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.markColor = [UIColor colorWithWhite:0 alpha:0.3];
        self.radius = 50;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self reLocation];
}

- (void)drawRect:(CGRect)rect
{
    //An opaque type that represents a Quartz 2D drawing environment.
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, self.markColor.CGColor);
    CGContextSetRGBFillColor (context,  0, 0, 0, .8);//设置填充颜色

    CGContextAddRect(context, rect);
    
    CGContextAddArc(context, self.targetCenter.x, self.targetCenter.y, self.radius/2, 0, 2*M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathEOFill); //根据坐标绘制路径
}

- (void)reLocation{
    if (!self.tooltip || !self.popTipView || !self.activity) return;
    UIView *anchorView = [self.tooltip getAnchorView:self.activity];
    CGPoint viewInContainer = [self convertPoint:anchorView.center fromView:anchorView.superview];
    
    self.radius = MIN(120, MAX(CGRectGetWidth(anchorView.frame), CGRectGetHeight(anchorView.frame)));
    self.targetCenter = viewInContainer;
    
    self.targetView.frame = CGRectMake(0, 0, self.radius, self.radius);
    self.targetView.center = self.targetCenter;

    [self setNeedsDisplay];
    
    [self.popTipView presentPointingAtView:self.targetView inView:self animated:YES];


}

- (void)showTooltip:(Tooltip *)tooltip activity:(UIViewController *)activity{
    self.tooltip = tooltip;
    self.activity = activity;
    UIView *anchorView = [tooltip getAnchorView:activity];
    CGPoint viewInContainer = [self convertPoint:anchorView.center fromView:anchorView.superview];

    self.radius = MIN(120, MAX(CGRectGetWidth(anchorView.frame), CGRectGetHeight(anchorView.frame)));
    self.targetCenter = viewInContainer;
    
    self.targetView.frame = CGRectMake(0, 0, self.radius, self.radius);
    self.targetView.center = self.targetCenter;
    
    [self setNeedsDisplay];
    
    [self showTipView];
}

- (void)showTipView{
    self.popTipView = [[CHPopTipView alloc] initWithMessage:self.tooltip.messageRes];
    self.popTipView.delegate = self;
    [self.popTipView layoutWithTooltip:self.tooltip];
    [self.popTipView presentPointingAtView:self.targetView inView:self animated:YES];

}

- (UIView *)targetView{
    if (!_targetView) {
        _targetView = [[UIView alloc] init];
        _targetView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_targetView];
    }
    return _targetView;
}

- (void)popTipViewWasDismissedByUser:(CHPopTipView *)popTipView{
    UIViewController *activity = self.activity;
    Tooltip *tooltip = self.tooltip;
    
    self.popTipView = nil;
    self.tooltip = nil;
    self.activity = nil;
    
    [[TooltipManager sharedInstance] onNextClicked:activity tooltip:tooltip];
    
    
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
