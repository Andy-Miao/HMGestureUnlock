//
//  HMGestureLockCoreView.m
//  PineappleFinancing
//  绘画手势锁 核心实现
//  Created by humiao on 2014/07/13.
//  Copyright © 2014 hm. All rights reserved.
//

#import "HMGestureLockCoreView.h"



NSString *BTN_NORMAL_IMAGE   = @"btn_normal_image";
NSString *BTN_SELECTED_IMAGE = @"btn_selected_image";

static NSUInteger const COLUMNS      = 3;
static NSUInteger const LINE_WIDTH   = 6;
static NSUInteger const LINE_COLORE  = 0xffc8ad;

@interface HMGestureLockCoreView ()

/// 记录选择的button数组
@property (nonatomic, strong) NSMutableArray <UIButton *> *selectedBtns;
/// 记录当前绘制的点
@property (nonatomic, assign) CGPoint currentPoint;
@end

@implementation HMGestureLockCoreView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        /// 绘制视图
        [self hm_setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /// 绘制视图
        [self hm_setupView];
    }
    return self;
}


#pragma mark - Custom method
- (void)hm_setupView {
    
    self.backgroundColor = [UIColor whiteColor];
    /// 创建视图
    for (NSUInteger i = 0 ; i < 9; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:BTN_NORMAL_IMAGE] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:BTN_SELECTED_IMAGE] forState:UIControlStateSelected];
        btn.tag = 1000+i;
        [self addSubview:btn];
    }
    
    /// 创建平移手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(hm_pan:)];
    [self addGestureRecognizer:pan];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    
    CGFloat x = 0,y = 0,w = 0,h = 0;
    if (CURRENT_SCREEN_WIDTH == 320) {
        w = 50;
        h = 50;
    } else {
        w = 58;
        h = 58;
    }
    
    CGFloat margin = (self.bounds.size.width - COLUMNS * w) / (COLUMNS + 1);//间距
    CGFloat col = 0;
    CGFloat row = 0;
    for (int i = 0; i < count; i++) {
        col = i%COLUMNS;
        row = i/COLUMNS;
        x = margin + (w+margin)*col;
        y = margin + (w+margin)*row;
        if (CURRENT_SCREEN_HEIGHT == 480) {
            y = (w+margin)*row;
        }else {
            y = margin + (w+margin) * row;
        }
        UIButton *btn = self.subviews[i];
        btn.frame = CGRectMake(x, y, w, h);
    }
}

#pragma mark - pan event
- (void)hm_pan:(UIPanGestureRecognizer *)pan {
    
    _currentPoint = [pan locationInView:self];
    
    [self setNeedsDisplay];
    for (UIButton *button in self.subviews) {
        if (CGRectContainsPoint(button.frame, _currentPoint) && button.selected == NO) {
            button.selected = YES;
            [self.selectedBtns addObject:button];
        }
    }
    [self layoutIfNeeded];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        //保存输入密码
        NSMutableString *gestureLockPwd = [NSMutableString string];
        for (UIButton *button in self.selectedBtns) {
            [gestureLockPwd appendFormat:@"%ld",button.tag-1000];
            button.selected = NO;
        }
        [self.selectedBtns removeAllObjects];
        //手势密码绘制完成后回调
        !self.hm_drawRectFinishedBlock?:self.hm_drawRectFinishedBlock(gestureLockPwd);
    }
}

#pragma mark - Getter
- (NSMutableArray <UIButton *> *)selectedBtns {
    
    if (!_selectedBtns) {
        _selectedBtns = @[].mutableCopy;
    }
    return _selectedBtns;
}


//只要调用这个方法就会把之前绘制的东西清空 重新绘制  我们以前的项目中是没有重新绘制的，代码是之前写了，今天重新整理下 Andy-Miao
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.selectedBtns.count > 3) {
        // 把所有选中按钮中心点连线
        UIBezierPath *path = [UIBezierPath bezierPath];
        NSUInteger count = self.selectedBtns.count;
        for (int i = 0; i < count; i++) {
            UIButton *btn = self.selectedBtns[i];
            if (i == 0) {
                [path moveToPoint:btn.center];
            }else {
                [path addLineToPoint:btn.center];
            }
        }
        [path addLineToPoint:_currentPoint ];
        [HMRGB(LINE_COLORE) set];
        path.lineJoinStyle = kCGLineJoinRound;
        path.lineWidth = LINE_WIDTH;
        [path stroke];
    }
}


@end
