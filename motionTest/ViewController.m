//
//  ViewController.m
//  motionTest
//
//  Created by user on 16/12/7.
//  Copyright © 2016年 zshuo50. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "nextViewController.h"

@interface ViewController ()
@property(nonatomic,strong)CMMotionManager *motionManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

      _motionManager = [[CMMotionManager alloc]init];
    
    
    //1.距离传感器  iPhone才有
    [UIDevice currentDevice].proximityMonitoringEnabled  =YES;
    //监听是否有物品靠近
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    
   
    
    //2.加速计
    if (_motionManager.isAccelerometerAvailable) {
        
        //设置采样间隔  实时采集
        _motionManager.accelerometerUpdateInterval = 1;
        [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            if (error) {
                return ;
            }
            //获取加速计信息
            CMAcceleration acceleration = accelerometerData.acceleration;
            NSLog(@"加速计Accelerayion_X:%f Y:%f Z:%f",acceleration.x,acceleration.y,acceleration.z);
        }];
    }else
    {
        NSLog(@"该设备不支持获取加速计数据");
    }
    
    //3.陀螺仪
    if (_motionManager.gyroAvailable) {
        _motionManager.gyroUpdateInterval = 1;
        [_motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
            if (error) {
                NSLog(@"获取陀螺仪数据出现错误");
            }
            NSLog(@"陀螺仪gyro:%f Y:%f Z:%f",gyroData.rotationRate.x,gyroData.rotationRate.y,gyroData.rotationRate.z);
        }];
    }else
    {
        NSLog(@"该设备不支持获取陀螺仪数据");
    }
  
    //4.磁场
    if (_motionManager.magnetometerAvailable) {
        _motionManager.magnetometerUpdateInterval = 1;
        [_motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMagnetometerData * _Nullable magnetometerData, NSError * _Nullable error) {
            if (error) {
                NSLog(@"获取磁场数据失败");
            }else{
                NSLog(@"磁场magnet_X:%f Y:%f Z:%f",magnetometerData.magneticField.x,magnetometerData.magneticField.y,magnetometerData.magneticField.z);
            }
            
        }];
    }else{
        NSLog(@"该设备不支持获取磁场数据");
    }
    

    //5.获取设备动作
    /*
     yaw角度：表示手机顶部转过的夹角。
     pitch角度：表示手机顶部或尾部翘起的角度。
     roll角度：表示手机左侧或右侧翘起的角度。
     */
    if (_motionManager.deviceMotionAvailable) {
        _motionManager.deviceMotionUpdateInterval = 1;
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            CMDeviceMotion *deviceMotion = _motionManager.deviceMotion;
            NSMutableString* str = [NSMutableString stringWithString:@"deviceMotion信息为：\n"];
            [str appendFormat:@"---attitude信息---\n"];
            [str appendFormat:@"attitude的yaw：%+.2f\n",deviceMotion.attitude.yaw];
            [str appendFormat:@"attitude的pitch：%+.2f\n" , deviceMotion.attitude.pitch];
            [str appendFormat:@"attitude的roll：%+.2f\n" , deviceMotion.attitude.roll];
            [str appendString:@"---rotationRate信息---\n"];
            [str appendFormat:@"rotationRate的X：%+.2f\n", deviceMotion.rotationRate.x];
            [str appendFormat:@"rotationRate的Y：%+.2f\n" , deviceMotion.rotationRate.y];
            [str appendFormat:@"rotationRate的Z：%+.2f\n" , deviceMotion.rotationRate.z];
            [str appendString:@"---gravity信息---\n"];
            [str appendFormat:@"gravity的X：%+.2f\n", deviceMotion.gravity.x];
            [str appendFormat:@"gravity的Y：%+.2f\n" , deviceMotion.gravity.y];
            [str appendFormat:@"gravity的Z：%+.2f\n" , deviceMotion.gravity.z];
            [str appendString:@"---magneticField信息---\n"];
            [str appendFormat:@"magneticField的精度：%d\n",
             deviceMotion.magneticField.accuracy];
            [str appendFormat:@"magneticField的X：%+.2f\n",
             deviceMotion.magneticField.field.x];
            [str appendFormat:@"magneticField的Y：%+.2f\n" ,
             deviceMotion.magneticField.field.y];
            [str appendFormat:@"magneticField的Z：%+.2f\n" ,
             deviceMotion.magneticField.field.z];
            
            NSLog(@"设备动作deviceStr==%@",str);
        }];
    }

    //6.ios7计步
    if ([CMStepCounter isStepCountingAvailable]) {
        //创建CMStepCounter对象
        CMStepCounter *stepCounter = [[CMStepCounter alloc]init];
        NSOperationQueue* queue = [[NSOperationQueue alloc]init];
        //开始收集计步信息，设置每行走5步执行一次代码块
        [stepCounter startStepCountingUpdatesToQueue:queue updateOn:5 withHandler:^(NSInteger numberOfSteps,                                                                       NSDate *timestamp, NSError *error) {
            NSLog(@"用户已经行走了【%ld】步",numberOfSteps);
        }];
    }else{
        NSLog(@"计步器不可用。");
    }
    
    //计步 ios8
    if ([CMPedometer isStepCountingAvailable]) {
        CMPedometer *pedometer = [[CMPedometer alloc] init];
        [pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData *pedometerData, NSError *error) {
            if (error) {
                NSLog(@"获取步数失败");
            }
           NSLog(@"用户已经行走了【%@】步",pedometerData.numberOfSteps);
            //步数    numberOfSteps
            //距离    distance
            //上楼    floorsAscended
            //下楼    floorsAscended
            
        }];
    }else
    {
        NSLog(@"不支持获取计步数据");
    }
    
    
    //7.运动数据
    if(CMMotionActivityManager.isActivityAvailable) {
        //创建CMMotionActivityManager对象
        CMMotionActivityManager *motionActivityManager = [[CMMotionActivityManager alloc]init];
        NSOperationQueue* queue = [[NSOperationQueue alloc]init];
        //开始收集运动数据，当收集到运动信息时执行传给该方法的代码块参数
        [motionActivityManager startActivityUpdatesToQueue:queue withHandler:^(CMMotionActivity *activity) {
            NSMutableString* str = [NSMutableString stringWithFormat:@"---运动信息---\n"];
            //获取运动信息
            [str appendFormat:@"是否步行：%d\n",activity.walking];
            [str appendFormat:@"是否跑步：%d\n",activity.running];
            [str appendFormat:@"是否驾车：%d\n",activity.automotive];
            [str appendFormat:@"是否静止：%d\n",activity.stationary];
            [str appendFormat:@"是否未知：%d\n",activity.unknown];
            NSLog(@"%@",str);
        }];
    }else{
        NSLog(@"该设备不支持获取运动数据");
    }
    
    
}





-(void)change:(NSNotificationCenter *)center
{
    if ([UIDevice currentDevice].proximityState == YES) {
        NSLog(@"有物体靠近");
    }else{
        NSLog(@"物体离开");
    }
}

#pragma mark - 摇一摇
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"开始摇一摇");
}

-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"摇一摇中断");
    
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"摇一摇结束");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
