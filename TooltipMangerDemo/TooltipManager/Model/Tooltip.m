//
//  Tooltip.m
//  ZHUKE5.0
//
//  Created by 陈浩 on 17/2/10.
//  Copyright © 2017年 beelieve. All rights reserved.
//

#import "Tooltip.h"
#import "UIViewController+TipView.h"

@interface Tooltip ()




@end

@implementation Tooltip

- (Tooltip *)initWithFlow:(TooltipFlow *)flow res:(NSString *)res anchorViewId:(NSString *)anchorViewId {
    self = [super init];
    if (self) {
        self.flow = flow;
        self.messageRes = res;
        self.anchorViewId = anchorViewId;
    }
    return self;
}


//public TooltipLayout createView(Activity activity) {
//    TooltipLayout layout = (TooltipLayout) activity.getLayoutInflater().inflate(R.layout.tooltip_layout, null);
//    layout.setTooltip(this);
//    return layout;
//}

- (UIView *)getAnchorView:(UIViewController *)inViewController{
    if (self.anchorViewId) {
        return [inViewController findViewByTipID:self.anchorViewId];
    }
    return nil;
}



@end
