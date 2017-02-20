//
//  ViewController.m
//  TooltipMangerDemo
//
//  Created by 陈浩 on 17/2/20.
//  Copyright © 2017年 beelieve. All rights reserved.
//

#import "ViewController.h"
#import "TooltipManager.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.nextBtn.tipID = @"next_button";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[TooltipManager sharedInstance] startFlowIfNeeded:self flowID:@"vc1"];

}


@end
