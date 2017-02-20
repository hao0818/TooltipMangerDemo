//
//  TooltipManager.m
//  ZHUKE5.0
//
//  Created by 陈浩 on 17/2/13.
//  Copyright © 2017年 beelieve. All rights reserved.
//

#import "TooltipManager.h"
#import "UIView+Frame.h"
#import "CHPopTipViewMarkView.h"
#import "Masonry.h"
#import <objc/runtime.h>

@interface TooltipManager ()

@property (nonatomic, assign) BOOL disableTooltips;
@property (nonatomic, strong) NSMutableDictionary *flows;
@property (nonatomic, weak) NSUserDefaults *userDefaults;
@property (nonatomic, assign) BOOL isShowingTooltip;

@property (nonatomic, strong) CHPopTipViewMarkView *tooltipLayoutContainer;




@end

@implementation TooltipManager

static TooltipManager *SINGLETON = nil;

static bool isFirstAccess = YES;

#pragma mark - Public Method

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL]init];
    });
    
    return SINGLETON;
}

#pragma mark - Life Cycle

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return [[TooltipManager alloc]init];
}

- (id)mutableCopy
{
    return [[TooltipManager alloc]init];
}

- (id) init
{
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    return self;
}

- (NSMutableDictionary *)flows{
    if (!_flows) {
        _flows = [@{} mutableCopy];
    }
    return _flows;
}

- (void)addFlow:(TooltipFlow *)flow{
    NSAssert([flow getId], @"flowId can't be nil!");
    self.flows[[flow getId]] = flow;
}

- (BOOL)isNotMarkedShown:(NSString *) s {
    BOOL b = false;
    s = getKeyForFlowShown(s);
    if (![self.userDefaults boolForKey:s]) {
        b = true;
    }
    return b;
}

NSString * getKeyForFlowShown(NSString * str) {
    return [@"tooltip_is_flow_shown_" stringByAppendingString:str];
}

NSString * getKeyForTooltipIndex(NSString * str) {
    return [@"tooltip_flow_" stringByAppendingString: str];
}


/*
 获取流程中最后一次展示的提示索引。
 */
- (NSInteger) getLastIndexOfFlow:(TooltipFlow *) tooltipFlow {
    NSString *  index = getKeyForTooltipIndex([tooltipFlow getId]);
    NSString *value = [self.userDefaults stringForKey:index];
    NSInteger lastIndex = -1;
    if (value && [value integerValue] >= 0) {
        lastIndex = [value integerValue];
    }
    return lastIndex;
}



- (Tooltip*) getNextTooltipToShow:(UIViewController *) activity flow: (TooltipFlow*) flow {
    if ([self isNotMarkedShown:[flow getId]]) {
        NSInteger i = [self getLastIndexOfFlow:flow] + 1;
        while (i < [flow getTooltipsCount]) {
            Tooltip * tooltip = [flow getToolTip:i];
            if ([self canShow:activity tooltip:tooltip]) {
                return tooltip;
            }
            i += 1;
        }
    }
    return nil;
}

- (BOOL) canShow:(UIViewController *) activity tooltip:(Tooltip *) tooltip{
    // 全局搜索框出现时，不展示工具提示
    UIView *anchorView = [tooltip getAnchorView:activity];
    if (anchorView == nil) {
        return NO;
    } else if(anchorView.superview){
        CGRect viewLocationInScreen = [anchorView.window convertRect:anchorView.frame fromView:anchorView.superview];
        if ((viewLocationInScreen.size.height == 0) || (viewLocationInScreen.size.width == 0)) {
            return NO;
        }
        CGPoint displaySize = CGPointMake(anchorView.window.frame.size.width, anchorView.window.frame.size.height);
        if ((viewLocationInScreen.origin.x >= 0) && ((viewLocationInScreen.origin.x+viewLocationInScreen.size.width) <= displaySize.x) && ((viewLocationInScreen.origin.y+viewLocationInScreen.size.height) <= displaySize.y) && (viewLocationInScreen.origin.y >= 0)) {
            return YES;
        }
        return NO;
    }else{
        return NO;
    }
}


- (void)startFlowIfNeeded:(UIViewController *)activity flowID:(NSString *)flowID{
    
    NSAssert(self.flows[flowID], @"flow is not registe!");
    Tooltip * nextTooltipToShow = [self getNextTooltipToShow:activity flow:self.flows[flowID]];
    if (nextTooltipToShow == nil || self.isShowingTooltip) {
    } else {
        self.isShowingTooltip = YES;
        [self showTooltip:activity tooltip:nextTooltipToShow];
    }
}

- (void)showTooltip:(UIViewController *) activity tooltip:(Tooltip *) tooltip{
//    ((BaseBaseActivity) activity).disableInteraction();
    if (self.tooltipLayoutContainer == nil) {
        self.tooltipLayoutContainer = [[CHPopTipViewMarkView alloc] init];
        self.tooltipLayoutContainer.backgroundColor = [UIColor clearColor];
        [activity.view.window addSubview:self.tooltipLayoutContainer];
        
        UIEdgeInsets padding = UIEdgeInsetsZero;

        [self.tooltipLayoutContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(activity.view.window).with.insets(padding);
        }];
    }
    
    [self.tooltipLayoutContainer showTooltip:tooltip activity:activity];
    
    TooltipFlow * flow = tooltip.flow;
    NSString * str = getKeyForTooltipIndex([flow getId]);
    NSInteger i = [flow getIndexOfTooptip:tooltip];
    
    [self.userDefaults setObject:[NSString stringWithFormat:@"%ld", (long)i] forKey:str];
    [self.userDefaults synchronize];
}

- (BOOL)canShowNextTooltip:(UIViewController *)activity flowID:(NSString *)flowID{
    if (self.disableTooltips) {
        return NO;
    }
    return [self getNextTooltipToShow:activity flow:self.flows[flowID]] != nil;
}
- (void)onFlowDone:(TooltipFlow *)flow{
    NSString *key = getKeyForFlowShown([flow getId]);
    [self.userDefaults setBool:YES forKey:key];
    [self.userDefaults synchronize];
}
- (void)onNextClicked:(UIViewController *)activity tooltip:(Tooltip *)tooltip{
    Tooltip * localTooltip = [self getNextTooltipToShow:activity flow:tooltip.flow];
    if (localTooltip != nil) {
        [self showTooltip:activity tooltip:localTooltip];
        return;
    }
    
    [self onFlowDone:tooltip.flow];
    [self dismissTooltip:activity tooltip:tooltip];
}
- (void)dismissTooltip:(UIViewController *)activity tooltip:(Tooltip *)tooltip{
    self.isShowingTooltip = NO;
    [self.tooltipLayoutContainer removeFromSuperview];
    self.tooltipLayoutContainer = nil;
}
- (void)resetAllFlows{
    
    for (NSString *str in self.flows.allKeys) {
        [self.userDefaults setBool:NO forKey:getKeyForFlowShown(str)];
        [self.userDefaults setObject:@"-1" forKey:getKeyForTooltipIndex(str)];
    }
    [self.userDefaults synchronize];
    
//    App.app().getPreferences().setProperty("is_user_saved_to_gallery", false);
}
- (BOOL)isVisible{
    return (self.tooltipLayoutContainer != nil) && (!self.tooltipLayoutContainer.isHidden);

}

- (void)setDisableTooltips:(BOOL)disableTooltips{
    _disableTooltips = disableTooltips;

}


@end
