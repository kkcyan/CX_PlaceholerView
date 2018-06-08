//
//  UIScrollView+PlaceholderView.m
//  UIScrollViewPlaceholderView
//
//  Created by Cyn X on 2018/6/8.
//  Copyright © 2018年 Cyn Van. All rights reserved.
//

#import "UIView+PlaceholderView.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <objc/runtime.h>


@interface UIView ()

/** 占位图 */
@property (nonatomic, strong) UIView *cx_placeholderView;
/** 用来记录UIScrollView最初的scrollEnabled */
@property (nonatomic, assign) BOOL cx_originalScrollEnabled;

@end

@implementation UIView (PlaceholderView)

static void *placeholderViewKey = &placeholderViewKey;
static void *originalScrollEnabledKey = &originalScrollEnabledKey;

- (UIView *)cx_placeholderView {
    return objc_getAssociatedObject(self, &placeholderViewKey);
}

- (void)setCx_placeholderView:(UIView *)cx_placeholderView {
    objc_setAssociatedObject(self, &placeholderViewKey, cx_placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)cx_originalScrollEnabled {
    return [objc_getAssociatedObject(self, &originalScrollEnabledKey) boolValue];
}

- (void)setCx_originalScrollEnabled:(BOOL)cx_originalScrollEnabled {
    objc_setAssociatedObject(self, &originalScrollEnabledKey, @(cx_originalScrollEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 自定义展示UIView及其子类的占位图
 
 @param type 占位图类型
 @param image 自定义img
 @param showTitle 自定义展示文本
 @param buttonTitle 自定义展示的按钮文本
 @param reloadBlock 重新加载回调的block
 */
- (void)cx_showPlaceholderViewWithType:(CQPlaceholderViewType)type customImg:(UIImage *)image showTitle:(NSString *)showTitle buttonTitle:(NSString *)buttonTitle reloadBlock:(void(^)(void))reloadBlock {
    
    // 如果是UIScrollView及其子类，占位图展示期间禁止scroll
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        // 先记录原本的scrollEnabled
        self.cx_originalScrollEnabled = scrollView.scrollEnabled;
        // 再将scrollEnabled设为NO
        scrollView.scrollEnabled = NO;
    }
    
    //------- 占位图 -------//
    if (self.cx_placeholderView) {
        [self.cx_placeholderView removeFromSuperview];
        self.cx_placeholderView = nil;
    }
    self.cx_placeholderView = [[UIView alloc] init];
    [self addSubview:self.cx_placeholderView];
    self.cx_placeholderView.backgroundColor = [UIColor whiteColor];
    [self.cx_placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(self);
    }];
    
    //------- 图标 -------//
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.cx_placeholderView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView.superview);
        make.centerY.mas_equalTo(imageView.superview).mas_offset(-80);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    //------- 描述 -------//
    UILabel *descLabel = [[UILabel alloc] init];
    [self.cx_placeholderView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(descLabel.superview);
        make.top.mas_equalTo(imageView.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(15);
    }];
    
    //------- 重新加载button -------//
    UIButton *reloadButton = [[UIButton alloc] init];
    [self.cx_placeholderView addSubview:reloadButton];
    [reloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [reloadButton setTitle:buttonTitle ? buttonTitle : @"重新加载" forState:UIControlStateNormal];
    reloadButton.layer.borderWidth = 1;
    reloadButton.layer.borderColor = [UIColor blackColor].CGColor;
    
    @weakify(self)
    [[reloadButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        
        // 执行block回调
        if (reloadBlock) {
            reloadBlock();
        }
        // 从父视图移除
        [self.cx_placeholderView removeFromSuperview];
        self.cx_placeholderView = nil;
        // 复原UIScrollView的scrollEnabled
        if ([self isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)self;
            scrollView.scrollEnabled = self.cx_originalScrollEnabled;
        }
    }];
    [reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(reloadButton.superview);
        make.top.mas_equalTo(descLabel.mas_bottom).mas_offset(20);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    
    //------- 根据type设置不同UI -------//
    switch (type) {
        case CQPlaceholderViewTypeNoNetwork: // 网络不好
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"无网" ofType:@"png"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
            descLabel.text = @"网络异常";
        }
            break;
            
        case CQPlaceholderViewTypeNoGoods: // 没商品
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"无商品" ofType:@"png"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
            descLabel.text = @"一个商品都没有";
        }
            break;
            
        case CQPlaceholderViewTypeNoComment: // 没评论
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"沙发" ofType:@"png"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
            descLabel.text = @"抢沙发！";
        }
            break;
        case CQPlaceholderViewTypeCustom: // 自定义
        {
            imageView.image = image;
            descLabel.text = showTitle;
        }
            break;
        default:
            break;
    }
    
}

/**
 展示UIView及其子类的占位图
 
 @param type 占位图类型
 @param reloadBlock 重新加载回调的block
 */
- (void)cx_showPlaceholderViewWithType:(CQPlaceholderViewType)type reloadBlock:(void (^)(void))reloadBlock {
    [self cx_showPlaceholderViewWithType:type customImg:nil showTitle:nil buttonTitle:nil reloadBlock:reloadBlock];
}

- (void)cx_showPlaceholerView {
    
    
    
}

/**
 主动移除占位图
 占位图会在你点击“重新加载”按钮的时候自动移除，你也可以调用此方法主动移除
 */
- (void)cx_removePlaceholderView {
    if (self.cx_placeholderView) {
        [self.cx_placeholderView removeFromSuperview];
        self.cx_placeholderView = nil;
    }
    // 复原UIScrollView的scrollEnabled
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        scrollView.scrollEnabled = self.cx_originalScrollEnabled;
    }
}

@end
