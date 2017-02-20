//
//  AppDelegate.h
//  TooltipMangerDemo
//
//  Created by 陈浩 on 17/2/20.
//  Copyright © 2017年 beelieve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

