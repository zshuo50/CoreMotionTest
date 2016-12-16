//
//  nextViewController.m
//  motionTest
//
//  Created by user on 16/12/16.
//  Copyright © 2016年 zshuo50. All rights reserved.
//

#import "nextViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface nextViewController ()

//判断传感器是否可用
@property(readonly,nonatomic,getter=isAccelerometerAvailable)BOOL accelerometerAvailable;
@property(readonly,nonatomic,getter=isGyroAvailable)BOOL gyroAvailable;
@property(readonly,nonatomic,getter=isMagnetometerAvailable)BOOL magnetometerAvailable;
//采样间隔
@property(nonatomic,assign)NSTimeInterval accelerometerUpdateInterval;
@property(nonatomic,assign)NSTimeInterval gyroUpdateInterval;
@property(nonatomic,assign)NSTimeInterval magnetometerUpdateInterval;

@end

@implementation nextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
