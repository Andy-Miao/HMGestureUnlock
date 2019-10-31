//
//  HMGestureUnlockView.m
//  PineappleFinancing
//  // 设置密码锁总入口
//  Created by humiao on 2014/07/13.
//  Copyright © 2014 hm. All rights reserved.
//

#import "HMGestureUnlockView.h"
#import "HMGestureLockCoreView.h"
#import "HMLockPreviewView.h"

NSString *const GESTURES_PASSWORD = @"gesturesPassword";

@interface HMGestureUnlockView () <UIAlertViewDelegate>

/// 提示图像
@property (nonatomic, weak) UIImageView *promptIV;
/// 返回设置
@property (nonatomic, weak) UIButton *backBtn;
/// 绘制密码的状态label
@property (nonatomic, weak) UILabel *statusL;
/// 重新设置
@property (nonatomic, weak) UIButton *resetBtn;
/// 密码锁值
@property (nonatomic, copy) NSString *gestureLockPwd;
/// 绘制后的预览小图
@property (nonatomic, weak) HMLockPreviewView *lockPreviewV;
/// 手绘的核心视图
@property (nonatomic, weak) HMGestureLockCoreView *lockCoreV;
///  当前处理密码类型 (默认是创建密码)
@property (nonatomic, assign) HMGestureType type;
///  操作完成回调
@property (nonatomic, copy) CompleteBlock block;

@end

@implementation HMGestureUnlockView
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        /// 创建视图
        [self hm_setupView];
        /// 默认创建密码
        self.type = HM_CREATE_LOCK;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /// 创建视图
        [self hm_setupView];
        
         self.type = HM_CREATE_LOCK;
    }
    return self;
}

#pragma mark - public methods
/// 展示手势密码视图 
+ (void)hm_showHMGestureUnlockViewType:(HMGestureType)type complete:(CompleteBlock)result {
    if(type == HM_UNLOCK && ![HMGestureUnlockView hm_getGesturesPassword].length) return;
    HMGestureUnlockView *unlockView = [[HMGestureUnlockView alloc] initWithFrame:CGRectMake(0, CURRENT_SCREEN_HEIGHT, CURRENT_SCREEN_WIDTH, CURRENT_SCREEN_HEIGHT)];
    [[UIApplication sharedApplication].keyWindow addSubview:unlockView];
    unlockView.block = [result copy];
    unlockView.type = type;
    [UIView animateWithDuration:0.25 animations:^{
         unlockView.frame = CGRectMake(0, 0, CURRENT_SCREEN_WIDTH - 20, CURRENT_SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        unlockView.frame = CGRectMake(0, 0, CURRENT_SCREEN_WIDTH, CURRENT_SCREEN_HEIGHT);
    }];
    
}

- (void)hm_hide {
    [UIView animateWithDuration:0.25 animations:^{
         self.frame = CGRectMake(0, CURRENT_SCREEN_HEIGHT, CURRENT_SCREEN_WIDTH, CURRENT_SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - Custom Method
/// 创建视图
- (void)hm_setupView {
    self.backgroundColor = [UIColor whiteColor];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeCenter;
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    self.backBtn = backBtn;
    
    UIImageView *promptIV = [[UIImageView alloc] init];
    promptIV.contentMode = UIViewContentModeCenter;
    [self addSubview:promptIV];
    self.promptIV = promptIV;
    
    UILabel *statusL = [[UILabel alloc] init];
    statusL.font = [UIFont fontWithName:@"PingFangSC" size:14];
    statusL.text = @"绘制解锁图案";
    statusL.textColor = HMRGB(0xff4b4b);
    statusL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:statusL];
    self.statusL = statusL;
    
    HMLockPreviewView *lockPreviewV = [[HMLockPreviewView alloc] init];
    [self addSubview:lockPreviewV];
    self.lockPreviewV = lockPreviewV;
    
    HMGestureLockCoreView *lockCoreV = [[HMGestureLockCoreView alloc] init];
    [self addSubview:lockCoreV];
    self.lockCoreV = lockCoreV;
    
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetBtn setTitle:@"重新设置" forState:UIControlStateNormal];
    [resetBtn setTitleColor:[UIColor colorWithWhite:.5 alpha:1] forState:UIControlStateNormal];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [resetBtn addTarget:self action:@selector(resetGestureLock) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:resetBtn];
    self.resetBtn = resetBtn;
    
    
}

/// 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backBtn.frame = CGRectMake(20, 40, 40, 40);
    self.promptIV.frame = CGRectMake((CURRENT_SCREEN_WIDTH - 36)/2.0, 56, 36, 32);
    self.statusL.frame = CGRectMake(0, CGRectGetMaxY(self.promptIV.frame)+8, CURRENT_SCREEN_WIDTH, 22);
    
    self.lockPreviewV.frame = CGRectMake((CURRENT_SCREEN_WIDTH - 36)/2.0, 56, 36, 32);
    self.lockCoreV.frame = CGRectMake(0, CGRectGetMaxY(self.lockPreviewV.frame)+60, CURRENT_SCREEN_WIDTH, CURRENT_SCREEN_WIDTH);
    
    self.resetBtn.frame = CGRectMake((CURRENT_SCREEN_WIDTH - 200)/2, CURRENT_SCREEN_HEIGHT - 70, 200, 30);
}

/// 根据不同的类型处理
- (void)hm_handleWithType:(HMGestureType)type password:(NSString *)gesturePassword {
    switch (type) {
        case HM_CREATE_LOCK ://创建手势密码
            [self hm_createGesturesPassword:gesturePassword];
            break;
        case HM_UNLOCK:      //解锁手势密码
            [self hm_validateGesturesPassword:gesturePassword];
            break;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    !self.block?:self.block(NO);
    [self hm_hide];
}

#pragma mark - event response
/// 重新设置
- (void)resetGestureLock {

    self.gestureLockPwd = nil;
    self.statusL.text = @"绘制解锁图案";
    self.resetBtn.hidden = YES;
    self.lockPreviewV.gesturesLockPassword = @"";
}

- (void)back {
    !self.block?:self.block(NO);
    [self hm_hide];
}

//创建手势密码
- (void)hm_createGesturesPassword:(NSString *)gesturesPassword {
    if (self.gestureLockPwd.length == 0) {
        if (gesturesPassword.length <4) {
            self.statusL.text = @"密码太短，最少4位，请重新操作";
            [self hm_shakeAnimationForView:self.statusL];
            return;
        }
        if (self.resetBtn.hidden == YES) {
            self.resetBtn.hidden = NO;
        }
        self.gestureLockPwd = gesturesPassword;
        self.lockPreviewV.gesturesLockPassword = self.gestureLockPwd;
        self.statusL.text = @"请再次绘制解锁图案";
        return;
    }
    if ([self.gestureLockPwd isEqualToString:gesturesPassword]) {//绘制成功
        //保存手势密码
        [HMGestureUnlockView hm_saveGesturesPassword:gesturesPassword];
        !self.block?:self.block(YES);
        [self hm_hide];
    }else {
        self.statusL.text = @"与上一次绘制不一致，请重新绘制";
        [self hm_shakeAnimationForView:self.statusL];
    }
}

/// 验证手势密码
- (void)hm_validateGesturesPassword:(NSString *)gesturesPassword {
    static NSInteger errorCount = 5;
    if ([gesturesPassword isEqualToString:[HMGestureUnlockView hm_getGesturesPassword]]) {
        errorCount = 5;
        !self.block?:self.block(YES);
        [self hm_hide];
    }else {
        if (errorCount - 1 == 0) {//你已经输错五次了！ 退出登陆！
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"手势密码已失效" message:@"请重新登陆" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新登陆", nil];
            [alertView show];
            errorCount = 5;
            return;
        }
        self.statusL.text = [NSString stringWithFormat:@"密码错误，还可以再输入%ld次",--errorCount];
        [self hm_shakeAnimationForView:self.statusL];
    }
}

//抖动动画
- (void)hm_shakeAnimationForView:(UIView *)view {
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - 10, position.y);
    CGPoint right = CGPointMake(position.x + 10, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES]; // 平滑结束
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
}


#pragma mark - other methods
///  是否已经创建过手势密码
+ (BOOL)hm_haveGesturePassword {
    return [HMGestureUnlockView hm_getGesturesPassword].length?YES:NO;
}

///  删除手势密码
+ (void)hm_deleteGesturesPassword {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GESTURES_PASSWORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 保存手势密码
+ (void)hm_saveGesturesPassword:(NSString *)gesturesPassword {
    [[NSUserDefaults standardUserDefaults] setObject:gesturesPassword forKey:GESTURES_PASSWORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///  获取手势密码
+ (NSString *)hm_getGesturesPassword {
    return [[NSUserDefaults standardUserDefaults] objectForKey:GESTURES_PASSWORD];
}

#pragma mark - getters and setters
///  设置密码的操作类型
- (void)setType:(HMGestureType)type {
    _type = type;
    self.lockPreviewV.hidden = _type != HM_CREATE_LOCK;
    self.promptIV.hidden = _type == HM_CREATE_LOCK;
    WS(self);
    [self.lockCoreV setHm_drawRectFinishedBlock:^(NSString *gesturePassword) {
        [weakself hm_handleWithType:type password:gesturePassword];
    }];
}
@end
