//
//  XSFluctuateView.h
//  xiangshangV3
//
//  Created by shiyabing on 16/2/29.
//  Copyright © 2016年 xiangshang360. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    XSFluctuateViewTypeRectangle,
    XSFluctuateViewTypeActionSheet,
} XSFluctuateViewType;

@protocol XSFluctuateViewDelegate <NSObject>

@optional

/**
 *  @author shiyabing, 16-03-04 18:03:17
 *
 *  @brief 代理方法 实现简单view逻辑
 *
 *  @param fluctuateView 浮动视图
 */
- (void)fluctuateView:(UIView *)fluctuateView;

/**
 *  @author shiyabing, 16-03-04 18:03:37
 *
 *  @brief 代理方法，实现item点击事件
 *
 *  @param fluctuateView self
 *  @param contentView   self.contentView
 *  @param index         self.itemIndex
 */
- (void)fluctuateView:(UIView *)fluctuateView content:(UIView *)contentView itemIndex:(NSInteger)index;

@end

@interface XSFluctuateView : UIView
@property (nonatomic, assign) NSInteger upCurrectItem;
@property (nonatomic, assign) NSInteger downCurrectItem;
@property (nonatomic, assign) BOOL isUpToDown;
@property(nonatomic,strong)NSArray *itemArray;
@property(nonatomic,strong)id<XSFluctuateViewDelegate>delegate;

/**
 初始化方法
 
 @param frame frame
 @param type type
 @param isUpToDown 是否从屏幕上方弹出
 @param contentHeight 内容高度
 @return <#return value description#>
 */
- (id)initWithFrame:(CGRect)frame type:(XSFluctuateViewType)type isUpToDown:(BOOL)isUpToDown screenCanUsedHeight:(CGFloat)contentHeight;

/**
 *  @author shiyabing, 16-03-04 18:03:59
 *
 *  @brief 显示浮动视图
 *
 *  @param parentView 要显示的父视图
 */
- (void)showInView:(UIView *)parentView;

/**
 *  @author shiyabing, 16-03-04 18:03:28
 *
 *  @brief 隐藏自己
 */
- (void)hideFluctuateView;

@end
