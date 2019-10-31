//
//  HMLockPreviewView.m
//  PineappleFinancing
//
//  Created by humiao on 2014/07/13.
//  Copyright © 2014 hm. All rights reserved.
//

#import "HMLockPreviewView.h"

static NSUInteger const COLUMNS               = 3;
static NSUInteger const BUTTON_WIDTH_HEIGHT   = 8;

@interface HMLockPreviewView ()

@property (nonatomic, strong) NSMutableArray <UIButton *> *btns;

@end

@implementation HMLockPreviewView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        /// 创建视图
        [self hm_setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        /// 创建视图
        [self hm_setupView];
    }
    return self;
}
#pragma mark - Custom method
- (void)hm_setupView {
    
    for (int i = 0; i < 9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:@"btn_normal_small_image"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_selected_small_image"] forState:UIControlStateSelected];
        [self addSubview:btn];
        [self.btns addObject:btn];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    CGFloat x = 0,y = 0;
     CGFloat widthMargin = (self.bounds.size.width - COLUMNS * BUTTON_WIDTH_HEIGHT) / ( COLUMNS - 1); //宽间距
       CGFloat heightMargin = (self.bounds.size.height - COLUMNS * BUTTON_WIDTH_HEIGHT) / (COLUMNS - 1); //高间距
    CGFloat col = 0;
    CGFloat row = 0;
    for (int i = 0; i < count; i++) {
        col = i%COLUMNS;
        row = i/COLUMNS;
        x = (BUTTON_WIDTH_HEIGHT+widthMargin)*col;
        y = (BUTTON_WIDTH_HEIGHT+heightMargin)*row;
        UIButton *btn = self.subviews[i];
        btn.frame = CGRectMake(x, y, BUTTON_WIDTH_HEIGHT, BUTTON_WIDTH_HEIGHT);
    }
}

- (void)setGesturesLockPassword:(NSString *)gesturesLockPassword {
    _gesturesLockPassword = gesturesLockPassword;
    
    for (UIButton *button in self.btns) {
        button.selected = NO;
    }
    for (int i = 0; i < _gesturesLockPassword.length; i++) {
        NSInteger index = [_gesturesLockPassword substringWithRange:NSMakeRange(i, 1)].integerValue;
        [self.btns[index] setSelected:YES];
    }
}

#pragma mark - Getter
- (NSMutableArray <UIButton *> *)btns {
    if (!_btns) {
        _btns = @[].mutableCopy;
    }
    return _btns;
}
@end
