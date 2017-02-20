//
//  UIViewController+TipView.h
//  ZHUKE5.0
//
//  Created by 陈浩 on 17/2/8.
//  Copyright © 2017年 beelieve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+TipView.h"

@interface UIViewController (TipView)

//- (void)showFlowIfNeeded:(NSString *)flow delay:(BOOL)delay;
- (UIView *)findViewByTipID:(NSString *)tipID;

@end
