# TooltipMangerDemo
1.在调用前预设置操作提示流程，如：
- (void)makeFlows{
    [[TooltipManager sharedInstance] addFlow:add(@"vc1")];
    [[TooltipManager sharedInstance] addFlow:add(@"vc2")];

}

TooltipFlow * add(NSString *str){
    TooltipFlow *flow = [[TooltipFlow alloc] initWithFlowID:str];
    if ([@"vc1" isEqualToString:str]) {
        [flow addTooltip:[[Tooltip alloc] initWithFlow:flow res:@"点此进入下一页!" anchorViewId:@"next_button"]];
    } else if ([@"vc2" isEqualToString:str]) {
        [flow addTooltip:[[Tooltip alloc] initWithFlow:flow res:@"我是第一个button" anchorViewId:@"button_1"]];
        [flow addTooltip:[[Tooltip alloc] initWithFlow:flow res:@"我是第二个button" anchorViewId:@"button_2"]];
    }
    return flow;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self makeFlows];
    });
    
    return YES;
}

2.给需要弹出提示框的view设置tipID，如：
self.nextBtn.tipID = @"next_button"; //与anchorViewId对应

3.在需要显示操作流程提示的位置调用以下代码：
    [[TooltipManager sharedInstance] startFlowIfNeeded:self flowID:@"vc1"]; //flowID即第一步中设置的flowid
  
    一般是加在视图控制器的viewDidAppear方法中， 如：
    - (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[TooltipManager sharedInstance] startFlowIfNeeded:self flowID:@"vc1"];

}
