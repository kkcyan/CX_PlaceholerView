//
//  UIScrollView+PlaceholderView.h
//  UIScrollViewPlaceholderView
//
//  Created by Cyn X on 2018/6/8.
//  Copyright © 2018年 Cyn Van. All rights reserved.
//

#import <UIKit/UIKit.h>

/** UIView的占位图类型 */
typedef NS_ENUM(NSInteger, CQPlaceholderViewType) {
    /** 没网 */
    CQPlaceholderViewTypeNoNetwork,
    /** 没商品 */
    CQPlaceholderViewTypeNoGoods,
    /** 没评论 */
    CQPlaceholderViewTypeNoComment,
    /** 自定义 */
    CQPlaceholderViewTypeCustom
};

@interface UIView (PlaceholderView)

/**
 展示UIView及其子类的占位图

 @param type 占位图类型
 @param reloadBlock 重新加载回调的block
 */
- (void)cx_showPlaceholderViewWithType:(CQPlaceholderViewType)type reloadBlock:(void(^)(void))reloadBlock;

/**
 自定义展示UIView及其子类的占位图

 @param type 占位图类型
 @param image 自定义img
 @param showTitle 自定义展示文本
 @param buttonTitle 自定义展示的按钮文本
 @param reloadBlock 重新加载回调的block
 */
- (void)cx_showPlaceholderViewWithType:(CQPlaceholderViewType)type customImg:(UIImage *)image showTitle:(NSString *)showTitle buttonTitle:(NSString *)buttonTitle reloadBlock:(void(^)(void))reloadBlock;

/**
 主动移除占位图
 占位图会在你点击“重新加载”按钮的时候自动移除，你也可以调用此方法主动移除
 */
- (void)cx_removePlaceholderView;

@end
