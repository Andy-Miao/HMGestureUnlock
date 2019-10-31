//
//  HMGestureUnlockViewController.m
//  HMGestureUnlock
//
//  Created by humiao on 2019/10/31.
//  Copyright © 2019 hm. All rights reserved.
//

#import "HMGestureUnlockViewController.h"
#import "HMGestureLockCoreView.h"
#import "HMLockPreviewView.h"

@interface HMGestureUnlockViewController ()

/// 提示图像
@property (nonatomic, weak) UIImageView *promptIV;
/// 提示语
@property (nonatomic, weak) UILabel *promptL;
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

@end

@implementation HMGestureUnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置手势密码";
    /// 创建视图
    [self hm_setupView];
    
    // Do any additional setup after loading the view.
}

#pragma mark - Custom Method
- (void)hm_setupView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetBtn setTitle:@"重设" forState:UIControlStateNormal];
    [resetBtn setTitleColor:[UIColor colorWithWhite:.5f alpha:1] forState:UIControlStateNormal];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    resetBtn.frame = CGRectMake(0, 0, 60, 40);
    [resetBtn addTarget:self action:@selector(hm_resetGestureLock) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:resetBtn];
    self.resetBtn = resetBtn;
    
    UIImageView *promptIV = [[UIImageView alloc] initWithFrame:CGRectMake((CURRENT_SCREEN_WIDTH - 36)/2.0, 56, 36, 32)];
    promptIV.contentMode = UIViewContentModeCenter;
    promptIV.image = [UIImage imageNamed:@"mine_gesture_unlock"];
    [self.view addSubview:promptIV];
    self.promptIV = promptIV;
    
    UILabel *promptL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.promptIV.frame)+8, CURRENT_SCREEN_WIDTH, 22)];
    promptL.font = [UIFont fontWithName:@"PingFangSC" size:16];
    promptL.text = @"";
    promptL.textColor = HMRGB(0x333333);
    promptL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:promptL];
    self.promptL = promptL;
    
    UILabel *statusL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.promptIV.frame)+8, CURRENT_SCREEN_WIDTH, 22)];
    statusL.font = [UIFont fontWithName:@"PingFangSC" size:14];
    statusL.text = @"绘制解锁图案";
    statusL.textColor = HMRGB(0xff4b4b);
    statusL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:statusL];
    self.statusL = statusL;
    
    HMLockPreviewView *lockPreviewV = [[HMLockPreviewView alloc] initWithFrame:CGRectMake((CURRENT_SCREEN_WIDTH - 36)/2.0, 56, 36, 32)];
    [self.view addSubview:lockPreviewV];
    self.lockPreviewV = lockPreviewV;
    
    HMGestureLockCoreView *lockCoreV = [[HMGestureLockCoreView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.statusL.frame)+60, CURRENT_SCREEN_WIDTH, CURRENT_SCREEN_WIDTH)];
    [self.view addSubview:lockCoreV];
    self.lockCoreV = lockCoreV;
    
    WS(self);
    [self.lockCoreV setHm_drawRectFinishedBlock:^(NSString *gesturePassword) {
        [weakself hm_handleWithType:weakself.type password:gesturePassword];
    }];
}

- (void)hm_hide{
    [self.navigationController popViewControllerAnimated:YES];
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

/// 重新设置
- (void)hm_resetGestureLock {

    self.gestureLockPwd = nil;
    self.statusL.text = @"绘制解锁图案";
    self.resetBtn.hidden = YES;
    self.lockPreviewV.gesturesLockPassword = @"";
}

#pragma mark - 手势密码
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
        [HMGestureUnlockViewController hm_saveGesturesPassword:gesturesPassword];
        !self.block?:self.block(YES);
        [self hm_hide];
    } else {
        self.statusL.text = @"与上一次绘制不一致，请重新绘制";
        [self hm_shakeAnimationForView:self.statusL];
    }
}

/// 验证手势密码
- (void)hm_validateGesturesPassword:(NSString *)gesturesPassword {
    static NSInteger errorCount = 5;
    if ([gesturesPassword isEqualToString:[HMGestureUnlockViewController hm_getGesturesPassword]]) {
        errorCount = 5;
        !self.block?:self.block(YES);
        [self hm_hide];
    }else {
        if (errorCount - 1 == 0) {//你已经输错五次了！ 退出登陆！
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"手势密码已失效" message:@"请重新登陆" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *Login = [UIAlertAction actionWithTitle:@"重新登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertController addAction:Login];
            [self presentViewController:alertController animated:YES completion:nil];
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
    return [HMGestureUnlockViewController hm_getGesturesPassword].length?YES:NO;
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
