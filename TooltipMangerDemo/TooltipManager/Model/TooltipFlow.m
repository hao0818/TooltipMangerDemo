//
//  TooltipFlow.m
//  ZHUKE5.0
//
//  Created by 陈浩 on 17/2/10.
//  Copyright © 2017年 beelieve. All rights reserved.
//

#import "TooltipFlow.h"

@interface TooltipFlow ()

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, strong) NSMutableArray *tooltips;

@end

@implementation TooltipFlow

- (instancetype)initWithFlowID:(NSString *)flowID{
    self = [super init];
    if (self) {
        self.ID = flowID;
    }
    return self;
}


/*
 获取指定提示
 */
- (Tooltip *)getToolTip:(NSInteger) i{
    if (self.tooltips.count == 0) {
        return nil;
    }
    return self.tooltips[i];

}

/*
 获取当前流程编号
 */
- (NSString *)getId{
    return _ID;
}

/*
 获取当前流程提示个数
 */
- (NSInteger)getTooltipsCount{
    return self.tooltips.count;
}

/*
 向当前流程增加提示
 */
- (void)addTooltip:(Tooltip *)tooltip{
    [self.tooltips addObject:tooltip];
}

/*
 获取指定提示的索引
 */
- (NSInteger)getIndexOfTooptip:(Tooltip *)tooltip{
    return [self.tooltips indexOfObject:tooltip];
}

/*
 是否为流程中最后一个提示
 */
- (BOOL)isLastTooltip:(Tooltip *)tooltip{
    return self.tooltips.count == [self.tooltips indexOfObject:tooltip] + 1;
}


/*
 获取指定提示的下一个提示。注：5.0.9 已弃用。
 */
- (Tooltip *)getNext:(Tooltip *)tooltip{
    NSInteger i = [self.tooltips indexOfObject:tooltip];
    if (i < self.tooltips.count - 1) {
        return self.tooltips[i+1];
    }
    return nil;
}

- (NSMutableArray *)tooltips{
    if (!_tooltips) {
        _tooltips = [@[] mutableCopy];
    }
    return _tooltips;
}

@end
