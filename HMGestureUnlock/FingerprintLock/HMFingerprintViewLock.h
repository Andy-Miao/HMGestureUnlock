//
//  HMFingerprintViewLock.h
//  PineappleFinancing
//
//  Created by humiao on 2014/07/13.
//  Copyright © 2014 hm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMFingerprintViewLock : NSObject

/**
 指纹验证
 @param callBack 验证结果
 */
+ (void)hm_fingerprintVerificationCallBack:(void(^)(NSError *error))callBack;

@end

NS_ASSUME_NONNULL_END
