//
//  ViewController2.m
//  TooltipMangerDemo
//
//  Created by 陈浩 on 17/2/20.
//  Copyright © 2017年 beelieve. All rights reserved.
//

#import "ViewController2.h"
#import "TooltipManager.h"

@interface ViewController2 ()

@property (strong, nonatomic) IBOutlet UIButton *btn1;
@property (strong, nonatomic) IBOutlet UIButton *btn2;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.btn1.tipID = @"button_1";
    self.btn2.tipID = @"button_2";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[TooltipManager sharedInstance] startFlowIfNeeded:self flowID:@"vc2"];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
