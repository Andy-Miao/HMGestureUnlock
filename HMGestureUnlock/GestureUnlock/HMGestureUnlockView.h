//
//  HMGestureUnlockView.h
//  PineappleFinancing
//
//  Created by humiao on 2014/07/13.
//  Copyright © 2014 hm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    HM_CREATE_LOCK,//创建手势密码
    HM_UNLOCK      //解锁手势密码
} HMGestureType;

/// 回调 result: 操作是否成功 
typedef void(^CompleteBlock)(BOOL result);
/// 存储密码的key
FOUNDATION_EXPORT NSString *const GESTURES_PASSWORD;
@interface HMGestureUnlockView : UIView

/// 是否已经创建过手势密码
+ (BOOL)hm_haveGesturePassword;

/// 获取手势密码
+ (NSString *)hm_getGesturesPassword;

/// 删除手势密码
+ (void)hm_deleteGesturesPassword;

/**
 展示手势密码视图
 @param type 类型 (HM_CREATE_LOCK)  创建手势密码 HM_UNLOCK //解锁手势密码)
 @param result 回调结果
 */
+ (void)hm_showHMGestureUnlockViewType:(HMGestureType)type complete:(CompleteBlock)result;

@end

NS_ASSUME_NONNULL_END
