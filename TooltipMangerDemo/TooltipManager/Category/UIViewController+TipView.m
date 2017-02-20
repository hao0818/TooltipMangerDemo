//
//  UIViewController+TipView.m
//  ZHUKE5.0
//
//  Created by 陈浩 on 17/2/8.
//  Copyright © 2017年 beelieve. All rights reserved.
//

#import "UIViewController+TipView.h"

@implementation UIViewController (TipView)

- (UIView *)findViewByTipID:(NSString *)tipID{
    return [self findSubView:self.view tipID:tipID];
}

-(UIView *)findSubView:(UIView*)view tipID:(NSString *)tipID
{
    for (UIView* subView in view.subviews)
    {
        if (subView.tipID && [subView.tipID isEqualToString:tipID]) {
            return subView;
        }
        
        UIView *v = [self findSubView:subView tipID:tipID];
        if(v) return v;
    }
    return nil;
}

@end
