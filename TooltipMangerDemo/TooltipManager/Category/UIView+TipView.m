//
//  UIView+TipView.m
//  ZHUKE5.0
//
//  Created by 陈浩 on 17/2/8.
//  Copyright © 2017年 beelieve. All rights reserved.
//

#import "UIView+TipView.h"
#import <objc/runtime.h>

static char *kMessage = "kMessage";
static char *kID = "kID";


@implementation UIView (TipView)

- (NSString *)message{
    return objc_getAssociatedObject(self, kMessage);
}

- (NSString *)tipID{
    return objc_getAssociatedObject(self, kID);
}

- (void)setMessage:(NSString *)message{
    objc_setAssociatedObject(self, kMessage, message, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTipID:(NSString *)tipID{
    objc_setAssociatedObject(self, kID, tipID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
