//
//  HMGestureUnlockViewController.h
//  HMGestureUnlock
//
//  Created by humiao on 2019/10/31.
//  Copyright © 2019 hm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMGestureUnlockView.h"
NS_ASSUME_NONNULL_BEGIN

/// 回调 result: 操作是否成功
typedef void(^OperatingCompleteBlock)(BOOL result);

@interface HMGestureUnlockViewController : UIViewController


///  当前处理密码类型 (默认是创建密码)
@property (nonatomic, assign) HMGestureType type;
///  操作完成回调
@property (nonatomic, copy) OperatingCompleteBlock block;
/// 是否已经创建过手势密码
+ (BOOL)hm_haveGesturePassword;

/// 获取手势密码
+ (NSString *)hm_getGesturesPassword;

/// 删除手势密码
+ (void)hm_deleteGesturesPassword;

@end

NS_ASSUME_NONNULL_END
