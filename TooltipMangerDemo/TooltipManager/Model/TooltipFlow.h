//
//  TooltipFlow.h
//  ZHUKE5.0
//
//  Created by 陈浩 on 17/2/10.
//  Copyright © 2017年 beelieve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tooltip.h"

@interface TooltipFlow : NSObject

- (instancetype)initWithFlowID:(NSString *)flowID;


/*
 获取指定提示
 */
- (Tooltip *)getToolTip:(NSInteger) i;

/*
 获取当前流程编号
 */
- (NSString *)getId;

/*
 获取当前流程提示个数
 */
- (NSInteger)getTooltipsCount;

/*
 向当前流程增加提示
 */
- (void)addTooltip:(Tooltip *)tooltip;

/*
 获取指定提示的索引
 */
- (NSInteger)getIndexOfTooptip:(Tooltip *)tooltip;

/*
 是否为流程中最后一个提示
 */
- (BOOL)isLastTooltip:(Tooltip *)tooltip;


/*
 获取指定提示的下一个提示。注：5.0.9 已弃用。
 */
- (Tooltip *)getNext:(Tooltip *)tooltip;

@end
