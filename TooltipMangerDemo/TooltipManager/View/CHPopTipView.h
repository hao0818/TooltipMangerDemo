//
//  CHPopTipView.h
//  ZHUKE5.0
//
//  Created by 陈浩 on 17/2/13.
//  Copyright © 2017年 beelieve. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PointDirectionUp = 0,
    PointDirectionDown
} PointDirection;

typedef enum {
    CHPopTipAnimationSlide = 0,
    CHPopTipAnimationPop
} CHPopTipAnimation;


@protocol CHPopTipViewDelegate;
@class Tooltip;

@interface CHPopTipView : UIView{
    
@private
    CGSize					bubbleSize;
    CGFloat					cornerRadius;
    BOOL					highlight;
    CGFloat					sidePadding;
    CGFloat					topMargin;
    PointDirection			pointDirection;
    CGFloat					pointerSize;
    CGPoint					targetPoint;
}

@property (nonatomic, strong)			UIColor					*backgroundColor;
@property (nonatomic, weak)		id<CHPopTipViewDelegate>	delegate;
@property (nonatomic, assign)			BOOL					disableTapToDismiss;
@property (nonatomic, assign)			BOOL					dismissTapAnywhere;
@property (nonatomic, strong)			NSString				*message;
@property (nonatomic, strong)           UIView	                *customView;
@property (nonatomic, strong, readonly)	id						targetObject;
@property (nonatomic, strong)			UIColor					*textColor;
@property (nonatomic, strong)			UIFont					*textFont;
@property (nonatomic, assign)			NSTextAlignment			textAlignment;
@property (nonatomic, strong)			UIColor					*borderColor;
@property (nonatomic, assign)			CGFloat					borderWidth;
@property (nonatomic, assign)           CHPopTipAnimation       animation;
@property (nonatomic, assign)           CGFloat                 maxWidth;

/* Contents can be either a message or a UIView */
- (id)initWithMessage:(NSString *)messageToShow;
- (id)initWithCustomView:(UIView *)aView;

- (void)presentPointingAtView:(UIView *)targetView inView:(UIView *)containerView animated:(BOOL)animated;
- (void)presentPointingAtBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;
- (void)autoDismissAnimated:(BOOL)animated atTimeInterval:(NSTimeInterval)timeInvertal;
- (PointDirection) getPointDirection;

- (void)layoutWithTooltip:(Tooltip *)tooltip;

@end


@protocol CHPopTipViewDelegate <NSObject>
- (void)popTipViewWasDismissedByUser:(CHPopTipView *)popTipView;

@end
