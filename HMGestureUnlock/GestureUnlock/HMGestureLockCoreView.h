//
//  HMGestureLockCoreView.h
//  PineappleFinancing
//
//  Created by humiao on 2014/07/13.
//  Copyright © 2014 hm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define CURRENT_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define CURRENT_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define WS(self) __weak typeof(self) weak##self = self;
#define HMRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface HMGestureLockCoreView : UIView

@property (nonatomic, copy) void(^hm_drawRectFinishedBlock)(NSString *gestureLockPwd);

@end

NS_ASSUME_NONNULL_END
