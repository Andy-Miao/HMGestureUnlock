//
//  ViewController.m
//  HMGestureUnlock
//
//  Created by humiao on 2019/10/30.
//  Copyright © 2019 hm. All rights reserved.
//

#import "ViewController.h"
#import "HMFingerprintViewLock.h"
#import "HMGestureUnlockView.h"
#import "HMGestureUnlockViewController.h"

@interface ViewController ()

@end

@implementation ViewController
/// 指纹
- (IBAction)hm_fingerprintViewLock:(id)sender {
    #if TARGET_IPHONE_SIMULATOR  //模拟器
    #elif TARGET_OS_IPHONE      //真机
        [HMFingerprintViewLock hm_fingerprintVerificationCallBack:^(NSError * _Nonnull error) {
            if (!error) {
                NSLog(@"指纹锁验证成功");
            } else {
                NSLog(@"指纹锁验证失败");
            }
        }];
    #endif
}
///  在此控制器内弹窗设置
- (IBAction)hm_popupGestureLock:(id)sender {
    [HMGestureUnlockView hm_showHMGestureUnlockViewType:HM_CREATE_LOCK complete:^(BOOL result) {
        NSLog(@"手势密码创建结果： %@",@(result));
    }];
    
}
/// 跳转到另外控制器设置
- (IBAction)hm_jumpGestureLock:(id)sender {
    HMGestureUnlockViewController *vc = [HMGestureUnlockViewController new];
    vc.type = HM_CREATE_LOCK;
    vc.block = ^(BOOL result) {
        NSLog(@"手势密码创建结果： %@",@(result));
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)hm_verificationGestureLock:(id)sender {
    [HMGestureUnlockView hm_showHMGestureUnlockViewType:HM_UNLOCK complete:^(BOOL result) {
        NSLog(@"手势密码创建结果： %@",@(result));
    }];
}

@end
