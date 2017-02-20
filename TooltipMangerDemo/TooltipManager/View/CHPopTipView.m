//
//  CHPopTipView.m
//  ZHUKE5.0
//
//  Created by 陈浩 on 17/2/13.
//  Copyright © 2017年 beelieve. All rights reserved.
//

#import "CHPopTipView.h"
#import "Masonry.h"
#import "Tooltip.h"
#import "TooltipFlow.h"

#define fBottom 40

@interface CHPopTipView ()

@property (nonatomic, strong) UILabel *counter;
@property (nonatomic, strong) UIButton *next;

@property (nonatomic, strong, readwrite)	id	targetObject;
@property (nonatomic, strong) NSTimer *autoDismissTimer;
@property (nonatomic, strong) UIButton *dismissTarget;


@end

@implementation CHPopTipView

@synthesize autoDismissTimer = _autoDismissTimer;
@synthesize backgroundColor;
@synthesize delegate;
@synthesize message;
@synthesize customView;
@synthesize targetObject;
@synthesize textColor;
@synthesize textFont;
@synthesize textAlignment;
@synthesize borderColor;
@synthesize borderWidth;
@synthesize animation;
@synthesize maxWidth;
@synthesize disableTapToDismiss;
@synthesize dismissTapAnywhere;
@synthesize dismissTarget=_dismissTarget;


- (CGRect)bubbleFrame {
    CGRect bubbleFrame;
    if (pointDirection == PointDirectionUp) {
        bubbleFrame = CGRectMake(2.0, targetPoint.y+pointerSize, bubbleSize.width, bubbleSize.height);
    }
    else {
        bubbleFrame = CGRectMake(2.0, targetPoint.y-pointerSize-bubbleSize.height, bubbleSize.width, bubbleSize.height);
    }
    return bubbleFrame;
}

- (CGRect)contentFrame {
    CGRect bubbleFrame = [self bubbleFrame];
    CGRect contentFrame = CGRectMake(bubbleFrame.origin.x + cornerRadius,
                                     bubbleFrame.origin.y + cornerRadius,
                                     bubbleFrame.size.width - cornerRadius*2,
                                     bubbleFrame.size.height - cornerRadius*2);
    return contentFrame;
}

- (void)layoutSubviews {
    if (self.customView) {
        
        CGRect contentFrame = [self contentFrame];
        [self.customView setFrame:contentFrame];
    }
}

- (void)drawRect:(CGRect)rect {
    
    CGRect bubbleRect = [self bubbleFrame];
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(c, 0.0, 0.0, 0.0, 1.0);	// black
    CGContextSetLineWidth(c, borderWidth);
    
    CGMutablePathRef bubblePath = CGPathCreateMutable();
    
    if (pointDirection == PointDirectionUp) {
        CGPathMoveToPoint(bubblePath, NULL, targetPoint.x, targetPoint.y);
        CGPathAddLineToPoint(bubblePath, NULL, targetPoint.x+pointerSize, targetPoint.y+pointerSize);
        
        CGPathAddArcToPoint(bubblePath, NULL,
                            bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y,
                            bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y+cornerRadius,
                            cornerRadius);
        CGPathAddArcToPoint(bubblePath, NULL,
                            bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y+bubbleRect.size.height,
                            bubbleRect.origin.x+bubbleRect.size.width-cornerRadius, bubbleRect.origin.y+bubbleRect.size.height,
                            cornerRadius);
        CGPathAddArcToPoint(bubblePath, NULL,
                            bubbleRect.origin.x, bubbleRect.origin.y+bubbleRect.size.height,
                            bubbleRect.origin.x, bubbleRect.origin.y+bubbleRect.size.height-cornerRadius,
                            cornerRadius);
        CGPathAddArcToPoint(bubblePath, NULL,
                            bubbleRect.origin.x, bubbleRect.origin.y,
                            bubbleRect.origin.x+cornerRadius, bubbleRect.origin.y,
                            cornerRadius);
        CGPathAddLineToPoint(bubblePath, NULL, targetPoint.x-pointerSize, targetPoint.y+pointerSize);
    }
    else {
        CGPathMoveToPoint(bubblePath, NULL, targetPoint.x, targetPoint.y);
        CGPathAddLineToPoint(bubblePath, NULL, targetPoint.x-pointerSize, targetPoint.y-pointerSize);
        
        CGPathAddArcToPoint(bubblePath, NULL,
                            bubbleRect.origin.x, bubbleRect.origin.y+bubbleRect.size.height,
                            bubbleRect.origin.x, bubbleRect.origin.y+bubbleRect.size.height-cornerRadius,
                            cornerRadius);
        CGPathAddArcToPoint(bubblePath, NULL,
                            bubbleRect.origin.x, bubbleRect.origin.y,
                            bubbleRect.origin.x+cornerRadius, bubbleRect.origin.y,
                            cornerRadius);
        CGPathAddArcToPoint(bubblePath, NULL,
                            bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y,
                            bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y+cornerRadius,
                            cornerRadius);
        CGPathAddArcToPoint(bubblePath, NULL,
                            bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y+bubbleRect.size.height,
                            bubbleRect.origin.x+bubbleRect.size.width-cornerRadius, bubbleRect.origin.y+bubbleRect.size.height,
                            cornerRadius);
        CGPathAddLineToPoint(bubblePath, NULL, targetPoint.x+pointerSize, targetPoint.y-pointerSize);
    }
    
    CGPathCloseSubpath(bubblePath);
    
    
    // Draw shadow
    CGContextAddPath(c, bubblePath);
    CGContextSaveGState(c);
    CGContextSetShadow(c, CGSizeMake(0, 3), 5);
    CGContextSetRGBFillColor(c, 0.0, 0.0, 0.0, 0.9);
    CGContextFillPath(c);
    CGContextRestoreGState(c);
    
    
    // Draw clipped background gradient
    CGContextAddPath(c, bubblePath);
    CGContextClip(c);
    
    CGFloat bubbleMiddle = (bubbleRect.origin.y+(bubbleRect.size.height/2)) / self.bounds.size.height;
    
    CGGradientRef myGradient;
    CGColorSpaceRef myColorSpace;
    size_t locationCount = 5;
    CGFloat locationList[] = {0.0, bubbleMiddle-0.03, bubbleMiddle, bubbleMiddle+0.03, 1.0};
    
    CGFloat colourHL = 0.0;
    if (highlight) {
        colourHL = 0.25;
    }
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    int numComponents = (int)CGColorGetNumberOfComponents([backgroundColor CGColor]);
    const CGFloat *components = CGColorGetComponents([backgroundColor CGColor]);
    if (numComponents == 2) {
        red = components[0];
        green = components[0];
        blue = components[0];
        alpha = components[1];
    }
    else {
        red = components[0];
        green = components[1];
        blue = components[2];
        alpha = components[3];
    }
    CGFloat colorList[] = {
        //red, green, blue, alpha
        red*1.16+colourHL, green*1.16+colourHL, blue*1.16+colourHL, alpha,
        red*1.16+colourHL, green*1.16+colourHL, blue*1.16+colourHL, alpha,
        red*1.08+colourHL, green*1.08+colourHL, blue*1.08+colourHL, alpha,
        red     +colourHL, green     +colourHL, blue     +colourHL, alpha,
        red     +colourHL, green     +colourHL, blue     +colourHL, alpha
    };
    myColorSpace = CGColorSpaceCreateDeviceRGB();
    myGradient = CGGradientCreateWithColorComponents(myColorSpace, colorList, locationList, locationCount);
    CGPoint startPoint, endPoint;
    startPoint.x = 0;
    startPoint.y = 0;
    endPoint.x = 0;
    endPoint.y = CGRectGetMaxY(self.bounds);
    
    CGContextDrawLinearGradient(c, myGradient, startPoint, endPoint,0);
    CGGradientRelease(myGradient);
    CGColorSpaceRelease(myColorSpace);
    
    //Draw Border
    int numBorderComponents = (int)CGColorGetNumberOfComponents([borderColor CGColor]);
    const CGFloat *borderComponents = CGColorGetComponents(borderColor.CGColor);
    CGFloat r, g, b, a;
    if (numBorderComponents == 2) {
        r = borderComponents[0];
        g = borderComponents[0];
        b = borderComponents[0];
        a = borderComponents[1];
    }
    else {
        r = borderComponents[0];
        g = borderComponents[1];
        b = borderComponents[2];
        a = borderComponents[3];
    }
    
    CGContextSetRGBStrokeColor(c, r, g, b, a);
    CGContextAddPath(c, bubblePath);
    CGContextDrawPath(c, kCGPathStroke);
    
    CGPathRelease(bubblePath);
    
    // Draw text
    if (self.message) {
        [textColor set];
        CGRect textFrame = [self contentFrame];
        
        NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        textStyle.lineBreakMode = NSLineBreakByWordWrapping;
        textStyle.alignment = self.textAlignment;
        
        [self.message drawInRect:textFrame withAttributes:@{NSFontAttributeName: textFont, NSParagraphStyleAttributeName:textStyle}];
    }
}

- (void)presentPointingAtView:(UIView *)targetView inView:(UIView *)containerView animated:(BOOL)animated {
    if (!self.targetObject) {
        self.targetObject = targetView;
    }
    
    // If we want to dismiss the bubble when the user taps anywhere, we need to insert
    // an invisible button over the background.
    if ( self.dismissTapAnywhere ) {
        self.dismissTarget = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.dismissTarget addTarget:self action:@selector(touchesBegan:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.dismissTarget setTitle:@"" forState:UIControlStateNormal];
        self.dismissTarget.frame = containerView.bounds;
        [containerView addSubview:self.dismissTarget];
    }
    
    [containerView addSubview:self];
    
    // Size of rounded rect
    CGFloat rectWidth;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // iPad
        if (maxWidth) {
            if (maxWidth < containerView.frame.size.width) {
                rectWidth = maxWidth;
            }
            else {
                rectWidth = containerView.frame.size.width - 20;
            }
        }
        else {
            rectWidth = (int)(containerView.frame.size.width/3);
        }
    }
    else {
        // iPhone
        if (maxWidth) {
            if (maxWidth < containerView.frame.size.width) {
                rectWidth = maxWidth;
            }
            else {
                rectWidth = containerView.frame.size.width - 10;
            }
        }
        else {
            rectWidth = (int)(containerView.frame.size.width*2/3);
        }
    }
    
    CGSize textSize = CGSizeZero;
    
    if (self.message!=nil) {
        
        NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
        NSStringDrawingUsesFontLeading;
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineBreakMode:NSLineBreakByCharWrapping];
        style.alignment = self.textAlignment;
        
        NSDictionary *attributes = @{ NSFontAttributeName : textFont, NSParagraphStyleAttributeName : style };
        textSize= [self.message boundingRectWithSize:CGSizeMake(rectWidth, 99999.0) options:opts attributes:attributes context:nil].size;
    }
    if (self.customView != nil) {
        textSize = self.customView.frame.size;
    }
    
    bubbleSize = CGSizeMake(textSize.width + cornerRadius*2, textSize.height + cornerRadius*2 + fBottom);
    
    UIView *superview = containerView.superview;
    if ([superview isKindOfClass:[UIWindow class]])
        superview = containerView;
    
    CGPoint targetRelativeOrigin    = [targetView.superview convertPoint:targetView.frame.origin toView:superview];
    CGPoint containerRelativeOrigin = [superview convertPoint:containerView.frame.origin toView:superview];
    
    CGFloat pointerY;	// Y coordinate of pointer target (within containerView)
    
    if (targetRelativeOrigin.y+targetView.bounds.size.height < containerRelativeOrigin.y) {
        pointerY = 0.0;
        pointDirection = PointDirectionUp;
    }
    else if (targetRelativeOrigin.y > containerRelativeOrigin.y+containerView.bounds.size.height) {
        pointerY = containerView.bounds.size.height;
        pointDirection = PointDirectionDown;
    }
    else {
        CGPoint targetOriginInContainer = [targetView convertPoint:CGPointMake(0.0, 0.0) toView:containerView];
        CGFloat sizeBelow = containerView.bounds.size.height - targetOriginInContainer.y;
        if (sizeBelow > targetOriginInContainer.y) {
            pointerY = targetOriginInContainer.y + targetView.bounds.size.height/2 + MAX(targetView.bounds.size.height, targetView.bounds.size.width)/2;
            pointDirection = PointDirectionUp;
        }
        else {
            pointerY = targetOriginInContainer.y + targetView.bounds.size.height/2 - MAX(targetView.bounds.size.height, targetView.bounds.size.width)/2;
            pointDirection = PointDirectionDown;
        }
    }
    
    if (pointDirection == PointDirectionDown) {
        __weak typeof(self) wSelf = self;
        [self.counter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.mas_left).with.offset(12).priorityLow();
            make.bottom.equalTo(wSelf.mas_bottom).with.offset(-12-pointerSize).priorityLow();
            make.width.greaterThanOrEqualTo(@(20)).priorityLow();
            make.height.equalTo(@(30)).priorityLow();

        }];
        
        [self.next mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wSelf.mas_right).with.offset(-12).priorityLow();
            make.bottom.equalTo(wSelf.mas_bottom).with.offset(-12-pointerSize).priorityLow();
            make.width.greaterThanOrEqualTo(@(20)).priorityLow();
            make.height.equalTo(@(30)).priorityLow();

        }];

    }else{
        __weak typeof(self) wSelf = self;
        [self.counter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.mas_left).with.offset(12).priorityLow();
            make.bottom.equalTo(wSelf.mas_bottom).with.offset(-12).priorityLow();
            make.width.greaterThanOrEqualTo(@(20)).priorityLow();
            make.height.equalTo(@(30)).priorityLow();

        }];
        
        [self.next mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wSelf.mas_right).with.offset(-12).priorityLow();
            make.bottom.equalTo(wSelf.mas_bottom).with.offset(-12).priorityLow();
            make.width.greaterThanOrEqualTo(@(20)).priorityLow();
            make.height.equalTo(@(30)).priorityLow();

        }];

    }
    
    
    CGFloat W = containerView.bounds.size.width;
    
    CGPoint p = [targetView.superview convertPoint:targetView.center toView:containerView];
    CGFloat x_p = p.x;
    CGFloat x_b = x_p - roundf(bubbleSize.width/2);
    if (x_b < sidePadding) {
        x_b = sidePadding;
    }
    if (x_b + bubbleSize.width + sidePadding > W) {
        x_b = W - bubbleSize.width - sidePadding;
    }
    if (x_p - pointerSize < x_b + cornerRadius) {
        x_p = x_b + cornerRadius + pointerSize;
    }
    if (x_p + pointerSize > x_b + bubbleSize.width - cornerRadius) {
        x_p = x_b + bubbleSize.width - cornerRadius - pointerSize;
    }
    
    CGFloat fullHeight = bubbleSize.height + pointerSize + 10.0;
    CGFloat y_b;
    if (pointDirection == PointDirectionUp) {
        y_b = topMargin + pointerY;
        targetPoint = CGPointMake(x_p-x_b, 0);
    }
    else {
        y_b = pointerY - fullHeight;
        targetPoint = CGPointMake(x_p-x_b, fullHeight-2.0);
    }
    
    CGRect finalFrame = CGRectMake(x_b-sidePadding,
                                   y_b,
                                   bubbleSize.width+sidePadding*2,
                                   fullHeight);
    
   	
    if (animated) {
        if (animation == CHPopTipAnimationSlide) {
            self.alpha = 0.0;
            CGRect startFrame = finalFrame;
            startFrame.origin.y += 10;
            self.frame = startFrame;
        }
        else if (animation == CHPopTipAnimationPop) {
            self.frame = finalFrame;
            self.alpha = 0.5;
            
            // start a little smaller
            self.transform = CGAffineTransformMakeScale(0.75f, 0.75f);
            
            // animate to a bigger size
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(popAnimationDidStop:finished:context:)];
            [UIView setAnimationDuration:0.15f];
            self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
            self.alpha = 1.0;
            [UIView commitAnimations];
        }
        
        [self setNeedsDisplay];
        
        if (animation == CHPopTipAnimationSlide) {
            [UIView beginAnimations:nil context:nil];
            self.alpha = 1.0;
            self.frame = finalFrame;
            [UIView commitAnimations];
        }
    }
    else {
        // Not animated
        [self setNeedsDisplay];
        self.frame = finalFrame;
    }
}

- (void)presentPointingAtBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated {
    UIView *targetView = (UIView *)[barButtonItem performSelector:@selector(view)];
    UIView *targetSuperview = [targetView superview];
    UIView *containerView = nil;
    if ([targetSuperview isKindOfClass:[UINavigationBar class]]) {
        UINavigationController *navController = (id)[(UINavigationBar *)targetSuperview delegate];
        containerView = [[navController topViewController] view];
    }
    else if ([targetSuperview isKindOfClass:[UIToolbar class]]) {
        containerView = [targetSuperview superview];
    }
    
    if (nil == containerView) {
        NSLog(@"Cannot determine container view from UIBarButtonItem: %@", barButtonItem);
        self.targetObject = nil;
        return;
    }
    
    self.targetObject = barButtonItem;
    
    [self presentPointingAtView:targetView inView:containerView animated:animated];
}

- (void)finaliseDismiss {
    [self.autoDismissTimer invalidate]; self.autoDismissTimer = nil;
    
    if (self.dismissTarget) {
        [self.dismissTarget removeFromSuperview];
        self.dismissTarget = nil;
    }
    
    [self removeFromSuperview];
    
    highlight = NO;
    self.targetObject = nil;
    
    [self notifyDelegatePopTipViewWasDismissedByUser];

}

- (void)dismissAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [self finaliseDismiss];
}

- (void)dismissAnimated:(BOOL)animated {
    
    if (animated) {
        CGRect frame = self.frame;
        frame.origin.y += 10.0;
        
        [UIView beginAnimations:nil context:nil];
        self.alpha = 0.0;
        self.frame = frame;
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(dismissAnimationDidStop:finished:context:)];
        [UIView commitAnimations];
    }
    else {
        [self finaliseDismiss];
    }
}

- (void)autoDismissAnimatedDidFire:(NSTimer *)theTimer {
    NSNumber *animated = [[theTimer userInfo] objectForKey:@"animated"];
    [self dismissAnimated:[animated boolValue]];
    [self notifyDelegatePopTipViewWasDismissedByUser];
}

- (void)autoDismissAnimated:(BOOL)animated atTimeInterval:(NSTimeInterval)timeInvertal {
    NSDictionary * userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:animated] forKey:@"animated"];
    
    self.autoDismissTimer = [NSTimer scheduledTimerWithTimeInterval:timeInvertal
                                                             target:self
                                                           selector:@selector(autoDismissAnimatedDidFire:)
                                                           userInfo:userInfo
                                                            repeats:NO];
}

- (void)notifyDelegatePopTipViewWasDismissedByUser {
    if (delegate && [delegate respondsToSelector:@selector(popTipViewWasDismissedByUser:)]) {
        [delegate popTipViewWasDismissedByUser:self];
    }
}

- (void)handleNext{
    highlight = YES;
    [self setNeedsDisplay];
    
    [self dismissAnimated:YES];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    if (self.disableTapToDismiss) {
//        [super touchesBegan:touches withEvent:event];
//        return;
//    }
//    
//    highlight = YES;
//    [self setNeedsDisplay];
//    
//    [self dismissAnimated:YES];
//    
//}

- (void)popAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // at the end set to normal size
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1f];
    self.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        self.opaque = NO;
        
        cornerRadius = 10.0;
        topMargin = 2.0;
        pointerSize = 12.0;
        sidePadding = 2.0;
        borderWidth = 1.0;
        
        self.textFont = [UIFont boldSystemFontOfSize:14.0];
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentLeft;
        self.backgroundColor = [UIColor whiteColor];
        self.borderColor = [UIColor blackColor];
        self.animation = CHPopTipAnimationSlide;
        self.dismissTapAnywhere = NO;
        
        self.counter = [[UILabel alloc] init];
        self.counter.textColor = [UIColor lightGrayColor];
        self.counter.font = [UIFont systemFontOfSize:15];
        
        self.next = [UIButton buttonWithType:UIButtonTypeSystem];
        self. next.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [self.next addTarget:self action:@selector(handleNext) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.next];
        [self addSubview:self.counter];
        
        __weak typeof(self) wSelf = self;
        [self.counter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wSelf.mas_left).with.offset(12).priorityLow();
            make.bottom.equalTo(wSelf.mas_bottom).with.offset(-12).priorityLow();
            make.width.greaterThanOrEqualTo(@(20)).priorityLow();
        }];
        
        [self.next mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wSelf.mas_right).with.offset(-12).priorityLow();
            make.bottom.equalTo(wSelf.mas_bottom).with.offset(-12).priorityLow();
            make.width.greaterThanOrEqualTo(@(20)).priorityLow();
        }];

    }
    return self;
}

- (PointDirection) getPointDirection {
    return pointDirection;
}

- (id)initWithMessage:(NSString *)messageToShow {
    CGRect frame = CGRectZero;
    
    if ((self = [self initWithFrame:frame])) {
        self.message = messageToShow;
    }
    return self;
}

- (id)initWithCustomView:(UIView *)aView {
    CGRect frame = CGRectZero;
    
    if ((self = [self initWithFrame:frame])) {
        self.customView = aView;
        [self addSubview:self.customView];
    }
    return self;
}


- (void)layoutWithTooltip:(Tooltip *)tooltip{
    if (tooltip) {
        NSInteger i = [tooltip.flow getIndexOfTooptip:tooltip];
        self.counter.text = [NSString stringWithFormat:@"%ld / %ld", (long)i+1, (long)[tooltip.flow getTooltipsCount]];
        
        if ([tooltip.flow isLastTooltip:tooltip]) {
            [self.next setTitle:@"完成" forState:UIControlStateNormal];
        }else{
            [self.next setTitle:@"下一步" forState:UIControlStateNormal];
        }
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
