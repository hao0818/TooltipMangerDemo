//
//  TooltipManager.h
//  ZHUKE5.0
//
//  Created by 陈浩 on 17/2/13.
//  Copyright © 2017年 beelieve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tooltip.h"
#import "TooltipFlow.h"
#import "TooltipFlow.h"
#import "UIView+TipView.h"
#import "UIViewController+TipView.h"

@interface TooltipManager : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (TooltipManager*)sharedInstance;

- (void)addFlow:(TooltipFlow *)flow;

- (void)startFlowIfNeeded:(UIViewController *)activity flowID:(NSString *)flowID;
- (BOOL)canShowNextTooltip:(UIViewController *)activity flowID:(NSString *)flowID;
- (void)onFlowDone:(TooltipFlow *)flow;
- (void)onNextClicked:(UIViewController *)activity tooltip:(Tooltip *)tooltip;
- (void)dismissTooltip:(UIViewController *)activity tooltip:(Tooltip *)tooltip;

- (void)resetAllFlows;
- (BOOL)isVisible;
- (void)setDisableTooltips:(BOOL)disableTooltips;


@end
