//
//  HMFingerprintViewLock.m
//  PineappleFinancing
//
//  Created by humiao on 2014/07/13.
//  Copyright © 2014 hm. All rights reserved.
//

#import "HMFingerprintViewLock.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation HMFingerprintViewLock

+ (void)hm_fingerprintVerificationCallBack:(void(^)(NSError *error))callBack;{
    //本地认证上下文联系对象
    LAContext * context = [[LAContext alloc] init];
    NSError * error = nil;
    //验证是否具有指纹认证功能
    BOOL canEvaluatePolicy = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        !callBack?:callBack(error);
    }
    if (canEvaluatePolicy) {
        NSLog(@"有指纹认证功能");
        //匹配指纹
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"验证指纹已确认您的身份" reply:^(BOOL success, NSError *error) {
            if (success) {
                NSLog(@"指纹验证成功");
                !callBack?:callBack(nil);
            } else {
                NSLog(@"验证失败");
                NSLog(@"%@",error.localizedDescription);
                !callBack?:callBack(error);
            }
        }];
    } else {
        NSLog(@"无指纹认证功能");
    }
}

@end
